#include "qemu/osdep.h"
#include "qemu/iov.h"
#include "qemu/module.h"
#include "qemu/timer.h"
#include "qemu/madvise.h"
#include "hw/virtio/virtio.h"
#include "hw/mem/pc-dimm.h"
#include "hw/qdev-properties.h"
#include "hw/boards.h"
#include "sysemu/balloon.h"
#include "hw/virtio/virtio-balloon.h"
#include "exec/address-spaces.h"
#include "qapi/error.h"
#include "qapi/qapi-events-machine.h"
#include "qapi/visitor.h"
#include "trace.h"
#include "qemu/error-report.h"
#include "migration/misc.h"
#include "migration/migration.h"
#include "migration/options.h"

#include "hw/virtio/virtio-bus.h"
#include "hw/virtio/virtio-access.h"

#include <stdio.h>

#define TYPE_VIRTIO_DUMMY "virtio-dummy"

struct VirtIODummy {
VirtIODevice parent_obj;
VirtQueue *ivq, *dvq, *svq, *free_page_vq, *reporting_vq;

VirtQueueElement *stats_vq_elem;
size_t config_size;
};
typedef struct VirtIODummy VirtIODummy;

OBJECT_DECLARE_SIMPLE_TYPE(VirtIODummy, VIRTIO_DUMMY)

#define VIRTIO_DUMMY_F_INJECT_INTERRUPT 1

static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
                                        Error **errp) {
VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
f |= dev->host_features;
virtio_add_feature(&f, VIRTIO_DUMMY_F_INJECT_INTERRUPT);

return f;
}

static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq) {}

static void virtio_balloon_device_realize(DeviceState *dev, Error **errp) {
VirtIODevice *vdev = VIRTIO_DEVICE(dev);
VirtIODummy *s = VIRTIO_DUMMY(dev);
int ret;

virtio_init(vdev, VIRTIO_ID_BALLOON, sizeof(s->config_size));
s->ivq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
}

static void virtio_dummy_class_init(ObjectClass *klass, void *data) {
DeviceClass *dc = DEVICE_CLASS(klass);
VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);

set_bit(DEVICE_CATEGORY_MISC, dc->categories);
vdc->realize = virtio_balloon_device_realize;
/* vdc->unrealize = virtio_balloon_device_unrealize; */
/* vdc->reset = virtio_balloon_device_reset; */
/* vdc->get_config = virtio_balloon_get_config; */
/* vdc->set_config = virtio_balloon_set_config; */
/* vdc->get_features = virtio_balloon_get_features; */
/* vdc->set_status = virtio_balloon_set_status; */
}

static void virtio_dummy_instance_init(Object *obj) {
VirtIODummy *s = VIRTIO_DUMMY(obj);
printf("[martins3:%s:%d] %p\n", __FUNCTION__, __LINE__, s);
}

static const TypeInfo virtio_dummy_info = {
.name = TYPE_VIRTIO_DUMMY,
.parent = TYPE_VIRTIO_DEVICE,
.instance_size = sizeof(VirtIODummy),
.instance_init = virtio_dummy_instance_init,
.class_init = virtio_dummy_class_init,
};

static void virtio_register_types(void) {
type_register_static(&virtio_dummy_info);
}

type_init(virtio_register_types)
