#!/usr/bin/env bash

id="00:1f.3"
readlink /sys/bus/pci/devices/0000:00:1f.3/iommu_group
ls -l /sys/bus/pci/devices/0000:00:1f.3/iommu_group/devices

lspci -n -s 0000:00:1f.3
# 00:1f.3 0403: 8086:9d71 (rev 21)
echo 0000:00:1f.3 >/sys/bus/pci/devices/0000:00:1f.3/driver/unbind
echo 8086 9d71 >/sys/bus/pci/drivers/vfio-pci/new_id

lspci -n -s 0000:00:1f.0
# 00:1f.0 0601: 8086:9d4e (rev 21)
echo 0000:00:1f.0 >/sys/bus/pci/devices/0000:00:1f.0/driver/unbind
echo 8086 9d4e >/sys/bus/pci/drivers/vfio-pci/new_id

lspci -n -s 0000:00:1f.2
# 00:1f.2 0580: 8086:9d21 (rev 21)
echo 0000:00:1f.2 >/sys/bus/pci/devices/0000:00:1f.2/driver/unbind
echo 8086 9d21 >/sys/bus/pci/drivers/vfio-pci/new_id

lspci -n -s 0000:00:1f.4
# 00:1f.4 0c05: 8086:9d23 (rev 21)
echo 0000:00:1f.4 >/sys/bus/pci/devices/0000:00:1f.4/driver/unbind
echo 8086 9d23 >/sys/bus/pci/drivers/vfio-pci/new_id
