#include <linux/rcuwait.h>
#include "internal.h"

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
