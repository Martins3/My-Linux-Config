# 参考 : https://stackoverflow.com/questions/22368264/compiling-out-of-tree-kernel-module-against-any-kernel-source-tree-on-the-filesy
# if KERNELRELEASE is defined, we've been invoked from the
# kernel build system and can use its language.
ifneq (${KERNELRELEASE},)
obj-m := hello.o
# Otherwise we were called directly from the command line.
# Invoke the kernel build system.
else
KERNEL_SOURCE := /home/martins3/core/linux
PWD := $(shell pwd)
default:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

clean:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
endif
