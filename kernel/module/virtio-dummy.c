#include <linux/virtio.h>
#include <linux/virtio_ids.h>
#include <linux/virtio_config.h>
#include <linux/module.h>

/* device private data (one per device) */
struct virtio_dummy_dev {
	struct virtqueue *vq;
};

static void virtio_dummy_recv_cb(struct virtqueue *vq)
{
	struct virtio_dummy_dev *dev = vq->vdev->priv;
	char *buf;
	unsigned int len;

	while ((buf = virtqueue_get_buf(dev->vq, &len)) != NULL) {
		/* process the received data */
	}
}

static int virtio_dummy_probe(struct virtio_device *vdev)
{
	struct virtio_dummy_dev *dev = NULL;

	/* initialize device data */
	dev = kzalloc(sizeof(struct virtio_dummy_dev), GFP_KERNEL);
	if (!dev)
		return -ENOMEM;

	/* the device has a single virtqueue */
	dev->vq = virtio_find_single_vq(vdev, virtio_dummy_recv_cb, "input");
	if (IS_ERR(dev->vq)) {
		kfree(dev);
		return PTR_ERR(dev->vq);
	}
	vdev->priv = dev;

	/* from this point on, the device can notify and get callbacks */
	virtio_device_ready(vdev);

	return 0;
}

static void virtio_dummy_remove(struct virtio_device *vdev)
{
	struct virtio_dummy_dev *dev = vdev->priv;

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
