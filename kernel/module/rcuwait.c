#include <linux/rcuwait.h>
#include "internal.h"
/**
  * 没有什么好资料，但是都是在 init commit 中
  * 8f95c90ceb541a38ac16fec48c05142ef1450c25
  */
static struct rcuwait manager_wait = __RCUWAIT_INITIALIZER(manager_wait);

static int state;
int test_rcuwait(int action)
{
	switch (action) {
	case 0:
		rcuwait_wait_event(&manager_wait, state, TASK_UNINTERRUPTIBLE);
		break;
	case 1:
		state = 1;
		rcuwait_wake_up(&manager_wait);
		break;
	}

	return 0;
}
