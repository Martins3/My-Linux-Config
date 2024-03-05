#include "qemu/osdep.h"
#include "qemu/iov.h"
#include "qemu/module.h"
#include "qemu/timer.h"
#include "qemu/madvise.h"
#include "hw/virtio/virtio.h"
#include "hw/mem/pc-dimm.h"
#include "hw/qdev-properties.h"
#include "hw/boards.h"
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
#define VIRTIO_ID_DUMMY 42

struct VirtIODummy {
  VirtIODevice parent_obj;
  VirtQueue *ivq, *dvq, *svq;
  size_t config_size;
};
typedef struct VirtIODummy VirtIODummy;

OBJECT_DECLARE_SIMPLE_TYPE(VirtIODummy, VIRTIO_DUMMY)

#define VIRTIO_DUMMY_F_INJECT_INTERRUPT 1

static uint64_t virtio_dummy_get_features(VirtIODevice *vdev, uint64_t f,
                                          Error **errp) {
  // TODO 不是太确定这里的实现
  /* VirtIODummy *dev = VIRTIO_DUMMY(vdev); */
  f |= VIRTIO_DUMMY_F_INJECT_INTERRUPT;
  virtio_add_feature(&f, VIRTIO_DUMMY_F_INJECT_INTERRUPT);

  return f;
}

static void virtio_dummy_handle_output(VirtIODevice *vdev, VirtQueue *vq) {
  /* VirtIODummy *s = VIRTIO_DUMMY(vdev); */
  VirtQueueElement *elem;

  for (;;) {
    size_t offset = 0;
    uint32_t pfn;

    elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
    if (!elem) {
      break;
    }
    while (iov_to_buf(elem->out_sg, elem->out_num, offset, &pfn, 4) == 4) {
      offset += 4;
      /* unsigned int p = virtio_ldl_p(vdev, &pfn); */
      /* printf("qemu receive : [%d]\n", p); */
    }

    virtqueue_push(vq, elem, 0);
    virtio_notify(vdev, vq);
    g_free(elem);
  }
}

static void virtio_dummy_device_realize(DeviceState *dev, Error **errp) {
  VirtIODevice *vdev = VIRTIO_DEVICE(dev);
  VirtIODummy *s = VIRTIO_DUMMY(dev);

  virtio_init(vdev, VIRTIO_ID_DUMMY, sizeof(s->config_size));
  s->ivq = virtio_add_queue(vdev, 128, virtio_dummy_handle_output);
}

static void virtio_dummy_device_unrealize(DeviceState *dev) {
  VirtIODevice *vdev = VIRTIO_DEVICE(dev);
  VirtIODummy *s = VIRTIO_DUMMY(dev);

  virtio_delete_queue(s->ivq);
  virtio_cleanup(vdev);
}

static void virtio_dummy_device_reset(VirtIODevice *vdev) {
  // TODO 什么时候调用 reset ?
}

static void virtio_dummy_get_config(VirtIODevice *vdev, uint8_t *config_data) {
  VirtIODummy *dev = VIRTIO_DUMMY(vdev);
  memcpy(config_data, &dev->config_size, sizeof(dev->config_size));
}

static void virtio_dummy_set_config(VirtIODevice *vdev,
                                    const uint8_t *config_data) {
  VirtIODummy *dev = VIRTIO_DUMMY(vdev);
  memcpy(&dev->config_size, config_data, sizeof(dev->config_size));
}

static void virtio_dummy_set_status(VirtIODevice *vdev, uint8_t status) {
  VirtIODummy *s = VIRTIO_DUMMY(vdev);
  // TODO 这个什么时候调用这个函数
}

static void virtio_dummy_class_init(ObjectClass *klass, void *data) {
  DeviceClass *dc = DEVICE_CLASS(klass);
  VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);

  set_bit(DEVICE_CATEGORY_MISC, dc->categories);
  vdc->realize = virtio_dummy_device_realize;
  vdc->unrealize = virtio_dummy_device_unrealize;
  vdc->reset = virtio_dummy_device_reset;
  vdc->get_config = virtio_dummy_get_config;
  vdc->set_config = virtio_dummy_set_config;
  vdc->get_features = virtio_dummy_get_features;
  vdc->set_status = virtio_dummy_set_status;
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

// ---------------------------------------- for pci
// ---------------------------------
#define PCI_DEVICE_ID_VIRTIO_DUMMY 0x1100
#include "hw/virtio/virtio-pci.h"
    typedef struct VirtIODummyPCI VirtIODummyPCI;

/*
 * virtio-dummy-pci: This extends VirtioPCIProxy.
 */
#define TYPE_VIRTIO_DUMMY_PCI "virtio-dummy-pci-base"
DECLARE_INSTANCE_CHECKER(VirtIODummyPCI, VIRTIO_DUMMY_PCI,
                         TYPE_VIRTIO_DUMMY_PCI)

struct VirtIODummyPCI {
  VirtIOPCIProxy parent_obj;
  VirtIODummy vdev;
};

static void virtio_dummy_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp) {
  VirtIODummyPCI *dev = VIRTIO_DUMMY_PCI(vpci_dev);
  DeviceState *vdev = DEVICE(&dev->vdev);

  vpci_dev->class_code = PCI_CLASS_OTHERS;
  qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
}

static void virtio_dummy_pci_class_init(ObjectClass *klass, void *data) {
  DeviceClass *dc = DEVICE_CLASS(klass);
  VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
  PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);
  k->realize = virtio_dummy_pci_realize;
  set_bit(DEVICE_CATEGORY_MISC, dc->categories);
  pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
  pcidev_k->device_id = PCI_DEVICE_ID_VIRTIO_DUMMY;
  pcidev_k->revision = VIRTIO_PCI_ABI_VERSION;
  pcidev_k->class_id = PCI_CLASS_OTHERS;
}

static void virtio_dummy_pci_instance_init(Object *obj) {
  VirtIODummyPCI *dev = VIRTIO_DUMMY_PCI(obj);

  virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
                              TYPE_VIRTIO_DUMMY);
}

static const VirtioPCIDeviceTypeInfo virtio_dummy_pci_info = {
    .base_name = TYPE_VIRTIO_DUMMY_PCI,
    .generic_name = "virtio-dummy-pci",
    .transitional_name = "virtio-dummy-pci-transitional",
    .non_transitional_name = "virtio-dummy-pci-non-transitional",
    .instance_size = sizeof(VirtIODummyPCI),
    .instance_init = virtio_dummy_pci_instance_init,
    .class_init = virtio_dummy_pci_class_init,
};

static void virtio_dummy_pci_register(void) {
  virtio_pci_types_register(&virtio_dummy_pci_info);
}

type_init(virtio_dummy_pci_register)
