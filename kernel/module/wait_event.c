#include "internal.h"
#include <linux/module.h>

static DECLARE_WAIT_QUEUE_HEAD(waitq);
static atomic_t ok = ATOMIC_INIT(0);

/**
 * DEFINE_WAIT_FUNC 的使用模式全部几乎都是类似这种模式，但是存在一些例外
 */
static void test(void)
{
	DEFINE_WAIT_FUNC(wait, woken_wake_function);
	add_wait_queue(&waitq, &wait);
	for (size_t i = 0; i < 3; i++) {
		pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
	}
	remove_wait_queue(&waitq, &wait);
}

int test_wait_event(int action)
{
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
	case 6:
		test();
		break;
	default:
		pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
		break;
	}

	return 0;
}
