#include "hacking.h"
#include <linux/module.h>

static DECLARE_WAIT_QUEUE_HEAD(waitq);
static atomic_t ok = ATOMIC_INIT(0);

ssize_t wait_event_store(struct kobject *kobj, struct kobj_attribute *attr,
			 const char *buf, size_t count)
{
	int ret;
	int action;
	ret = kstrtoint(buf, 10, &action);
	if (ret < 0)
		return ret;

	switch (action) {
	case 0:
    // wake_up 和 wake_up_all 的区别 :
    // 1. 到底是唤醒一个 thread ，还是所在的 thread group 中的所有的 thread
    // 2. 如果是不同的 thread group 等待到同一个 waitq 上，wake_up(&waitq) 会将他们都唤醒
		wake_up(&waitq);
		break;
	case 1:
    atomic_set(&ok, 1);
		break;
  case 2:
    atomic_set(&ok, 0);
		break;
	case 3:
		wait_event_interruptible(waitq, atomic_read(&ok));
		break;
	case 4:
		wait_event_killable(waitq, atomic_read(&ok));
		break;
	case 5:
		wait_event(waitq, atomic_read(&ok));
		break;
	default:
		pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
		break;
	}

	return count;
}
