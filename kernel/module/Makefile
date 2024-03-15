# 参考 : https://stackoverflow.com/questions/22368264/compiling-out-of-tree-kernel-module-against-any-kernel-source-tree-on-the-filesy
# 但是是 M=${PWD} 而不是 SOURCES=${PWD}
#
# if KERNELRELEASE is defined, we've been invoked from the
# kernel build system and can use its language.
ifneq (${KERNELRELEASE},)
$(info call this in kernel environment)
obj-m += martins3.o

# https://stackoverflow.com/questions/56429389/expand-macros-of-a-single-file-when-compiling-linux-kernel
CFLAGS_access-once.o := -save-temps=obj

martins3-m := hello.o seq.o seq2.o workqueue.o thread.o mutex.o \
	tracepoint.o rcu.o srcu.o wait_event.o atomic.o barrier.o \
	rw_semaphore.o completion.o percpu-rwsem.o preempt.o \
	 rcuwait.o waitbit.o swait.o access-once.o seqlock.o

obj-m += virtio-dummy.o



virtio-dummy:= virtio-dummy.o

# Otherwise we were called directly from the command line.
# Invoke the kernel build system.
else
KERNEL_SOURCE := ~/core/linux-build
PWD := $(shell pwd)
default:
	${MAKE} -C ${KERNEL_SOURCE} M=${PWD} modules

clean:
	${MAKE} -C ${KERNEL_SOURCE} M=${PWD} clean
endif
