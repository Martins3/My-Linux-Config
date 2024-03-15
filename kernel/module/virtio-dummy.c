#include <linux/virtio.h>
#include <linux/virtio_ids.h>
#include <linux/virtio_config.h>
#include <linux/module.h>
#include <linux/blk-mq.h>
#include "internal.h"
#include <linux/delay.h>

#define VIRTIO_ID_DUMMY 42

/* device private data (one per device) */
struct virtio_dummy_dev {
	struct virtqueue *vq;
	struct blk_mq_tag_set *tag_set;
	struct gendisk *disk;

	spinlock_t lock;
	// send a pointer to qemu
	struct request *req;
	// qemu return the the same thing to kernel
	struct request *ret;
};

/* static struct virtio_dummy_dev *dummy_dev; */

DECLARE_TESTER(echo)
DEFINE_TESTER(echo)
int test_echo(int action)
{
	return 0;
}

static struct attribute *attrs[] = {
	&echo_attribute.attr,
	NULL, /* need to NULL terminate the list of attributes */
};

static struct attribute_group attr_group = {
	.attrs = attrs,
};

static struct kobject *dummy;
static int init_dummy_sysfs(void)
{
	int error = 0;
	dummy = kobject_create_and_add("dummy", kernel_kobj);
	if (!dummy)
		return -ENOMEM;

	error = sysfs_create_group(dummy, &attr_group);
	if (error)
		kobject_put(dummy);

	return error;
	return 0;
}

static void exit_dummy_sysfs(void)
{
	kobject_put(dummy);
}

static void dummy_complete_rq(struct request *req)
{
	blk_mq_end_request(req, BLK_STS_OK);
}

// 参考 virtblk_add_req 和 __virtscsi_add_cmd
static blk_status_t dummy_queue_rq(struct blk_mq_hw_ctx *hctx,
				   const struct blk_mq_queue_data *bd)
{
	int err;
	unsigned long flags;
	struct request *req = bd->rq;
	struct virtio_dummy_dev *dummy_dev = hctx->queue->queuedata;
	blk_mq_start_request(req);
	struct scatterlist *sgs[2];

	struct scatterlist sg_in;
	struct scatterlist sg_out;
	dummy_dev->req = req;

	sg_init_one(&sg_out, &dummy_dev->req, sizeof(dummy_dev->req));
	sgs[0] = &sg_out;

	sg_init_one(&sg_in, &dummy_dev->ret, sizeof(dummy_dev->ret));
	sgs[1] = &sg_in;

	spin_lock_irqsave(&dummy_dev->lock, flags);
	err = virtqueue_add_sgs(dummy_dev->vq, sgs, 1, 1, req, GFP_KERNEL);
	if (err) {
		virtqueue_kick(dummy_dev->vq);
		/* Don't stop the queue if -ENOMEM: we may have failed to
		 * bounce the buffer due to global resource outage.
		 */
		if (err == -ENOSPC) {
			blk_mq_stop_hw_queue(hctx);
		}
		spin_unlock_irqrestore(&dummy_dev->lock, flags);
		return BLK_STS_DEV_RESOURCE;
	}
	spin_unlock_irqrestore(&dummy_dev->lock, flags);
	virtqueue_notify(dummy_dev->vq);
	return BLK_STS_OK;
}

static const struct blk_mq_ops dummy_mq_ops = {
	.queue_rq = dummy_queue_rq,
	.complete = dummy_complete_rq,
};

// 参考 dm_mq_init_request_queue 和 nullblk 的实现
static int dummy_init_request_queue(struct virtio_dummy_dev *dummy)
{
	int err;
	struct blk_mq_tag_set *tag_set;
	BUG_ON(dummy == NULL);

	tag_set = kzalloc_node(sizeof(struct blk_mq_tag_set), GFP_KERNEL,
			       NUMA_NO_NODE);
	if (!tag_set)
		return -ENOMEM;

	tag_set->ops = &dummy_mq_ops;
	tag_set->queue_depth = 17;
	tag_set->numa_node = NUMA_NO_NODE;
	tag_set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_STACKING;
	tag_set->nr_hw_queues = 2;
	tag_set->driver_data = dummy;

	tag_set->cmd_size = 0; // cmd_size 是 driver 的附属数据

	err = blk_mq_alloc_tag_set(tag_set);
	if (err)
		goto out_kfree_tag_set;

	dummy->tag_set = tag_set;

	spin_lock_init(&dummy->lock);
	return 0;

out_kfree_tag_set:
	kfree(tag_set);
	return err;
}

static const struct block_device_operations dummy_rq_ops = {
	.owner = THIS_MODULE,
};

static int dummy_init_disk(struct virtio_dummy_dev *dummy)
{
	int rv = 0;
	int null_major;

	null_major = register_blkdev(0, "dummy-null");
	if (null_major < 0) {
		rv = null_major;
		goto fail;
	}

	dummy->disk = blk_mq_alloc_disk(dummy->tag_set, NULL, dummy);
	if (IS_ERR(dummy->disk)) {
		rv = PTR_ERR(dummy->disk);
		goto fail;
	}

	set_capacity(dummy->disk, (33 * SZ_1M) >> SECTOR_SHIFT);

	dummy->disk->major = null_major;
	dummy->disk->first_minor = 1;
	dummy->disk->minors = 1;
	dummy->disk->fops = &dummy_rq_ops;
	strncpy(dummy->disk->disk_name, "dummy", DISK_NAME_LEN);
	return add_disk(dummy->disk);
fail:
	return rv;
}

/**
 * 调用路径为:
 *
 * virtio_dummy_recv_cb+0x34/0x90 [virtio_dummy]
 * vring_interrupt+0x5b/0x90
 * vp_vring_interrupt+0x57/0x90
 * __handle_irq_event_percpu+0x6d/0x1d0
 * handle_irq_event+0x38/0x80
 * handle_fasteoi_irq+0x7c/0x210
 * __common_interrupt+0x3c/0xa0
 * common_interrupt+0x83/0xa0
 *
 * 参考实现: virtblk_done
 */
static void virtio_dummy_recv_cb(struct virtqueue *vq)
{
	struct virtio_dummy_dev *dev = vq->vdev->priv;
	struct request *req;
	unsigned int len;
	unsigned long flags;

	BUG_ON(!in_interrupt());
	// msleep(100);
	// 无论是在中断中，还是在软中断中睡眠，
	// 最终在 __schedule -> __schedule_bug 中触发 crash

	spin_lock_irqsave(&dev->lock, flags);
	while ((req = virtqueue_get_buf(dev->vq, &len)) != NULL) {
		BUG_ON(len != 8);
		blk_mq_complete_request(req);
	}
	spin_unlock_irqrestore(&dev->lock, flags);
}

static int virtio_dummy_probe(struct virtio_device *vdev)
{
	struct virtio_dummy_dev *dev;
	int rv;
	if (init_dummy_sysfs())
		return -ENOMEM;
	pr_info("virtio dummy probe");

	dev = kzalloc(sizeof(struct virtio_dummy_dev), GFP_KERNEL);
	if (!dev)
		return -ENOMEM;

	/* the device has a single virtqueue */
	dev->vq = virtio_find_single_vq(vdev, virtio_dummy_recv_cb, "input");
	if (IS_ERR(dev->vq)) {
		return PTR_ERR(dev->vq);
	}
	vdev->priv = dev;

	rv = dummy_init_request_queue(dev);
	if (rv)
		return rv;

	rv = dummy_init_disk(dev);
	if (rv)
		return rv;

	/* from this point on, the device can notify and get callbacks */
	virtio_device_ready(vdev);

	return 0;
}

static void virtio_dummy_remove(struct virtio_device *vdev)
{
	struct virtio_dummy_dev *dev = vdev->priv;
	void *buf;

	/*
		 * disable vq interrupts: equivalent to
		 * vdev->config->reset(vdev)
		 */
	virtio_reset_device(vdev);

	/* detach unused buffers */
	while ((buf = virtqueue_detach_unused_buf(dev->vq)) != NULL) {
		kfree(buf);
	}

	/* remove virtqueues */
	vdev->config->del_vqs(vdev);

	exit_dummy_sysfs();

	del_gendisk(dev->disk);
	put_disk(dev->disk);
	blk_mq_free_tag_set(dev->tag_set);

	kfree(dev);
}

static const struct virtio_device_id id_table[] = {
	{ VIRTIO_ID_DUMMY, VIRTIO_DEV_ANY_ID },
	{ 0 },
};

static struct virtio_driver virtio_dummy_driver = {
	.driver.name = KBUILD_MODNAME,
	.driver.owner = THIS_MODULE,
	.id_table = id_table,
	.probe = virtio_dummy_probe,
	.remove = virtio_dummy_remove,
};

module_virtio_driver(virtio_dummy_driver);
MODULE_DEVICE_TABLE(virtio, id_table);
MODULE_DESCRIPTION("Dummy virtio driver");
MODULE_LICENSE("GPL");
