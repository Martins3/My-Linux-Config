#include <linux/virtio.h>
#include <linux/virtio_ids.h>
#include <linux/virtio_config.h>
#include <linux/module.h>
#include "internal.h"

#define VIRTIO_ID_DUMMY 42

/* device private data (one per device) */
struct virtio_dummy_dev {
	struct virtqueue *vq;
};

static struct virtio_dummy_dev virtio_dummy_dev;

DECLARE_TESTER(echo)
DEFINE_TESTER(echo)

static void tell_host(int num)
{
	struct scatterlist sg;
	// XXX 不要在乎这里的内存泄露。发现传递给 sg_init_one 的第二个参数是数据段，最后传输到 qemu 实际上是 0
	int *x = (int *)kmalloc(sizeof(int), GFP_KERNEL);
	*x = num;
	sg_init_one(&sg, x, sizeof(int));
	virtqueue_add_outbuf(virtio_dummy_dev.vq, &sg, 1, &virtio_dummy_dev,
			     GFP_KERNEL);
	virtqueue_kick(virtio_dummy_dev.vq);
}

int test_echo(int action)
{
	if (action == 123)
		for (int i = 0; i < 100000; i++)
			tell_host(action);
	tell_host(action);
	return 0;
}

static struct attribute *attrs[] = {
	&echo_attribute.attr,
	NULL, /* need to NULL terminate the list of attributes */
};

static struct attribute_group attr_group = {
	.attrs = attrs,
};

static struct kobject *mymodule;
static int init_dummy_sysfs(void)
{
	int error = 0;
	mymodule = kobject_create_and_add("dummy", kernel_kobj);
	if (!mymodule)
		return -ENOMEM;

	error = sysfs_create_group(mymodule, &attr_group);
	if (error)
		kobject_put(mymodule);

	return error;
	return 0;
}

static void exit_dummy_sysfs(void)
{
	kobject_put(mymodule);
}

static void virtio_dummy_recv_cb(struct virtqueue *vq)
{
	struct virtio_dummy_dev *dev = vq->vdev->priv;
	char *buf;
	unsigned int len;

	int i = 0;
	while ((buf = virtqueue_get_buf(dev->vq, &len)) != NULL) {
		if (i++ % 1000 == 0)
			pr_info("receive : [%s]", buf);
	}
}

static int virtio_dummy_probe(struct virtio_device *vdev)
{
	if (init_dummy_sysfs())
		return -ENOMEM;
	pr_info("virtio dummy probe");

	/* the device has a single virtqueue */
	virtio_dummy_dev.vq =
		virtio_find_single_vq(vdev, virtio_dummy_recv_cb, "input");
	if (IS_ERR(virtio_dummy_dev.vq)) {
		return PTR_ERR(virtio_dummy_dev.vq);
	}
	vdev->priv = &virtio_dummy_dev;

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
