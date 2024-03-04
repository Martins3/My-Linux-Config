#include "internal.h"
#include <linux/completion.h>

static DECLARE_COMPLETION(test);

/**
 * completion 和 wait_event 机制的差别
 * 1. 没有处理信号的接口
 * 2. 没有判断条件的接口
 */
int test_complete(int action)
{
	switch (action) {
	case 0:
    complete(&test);
		break;
	case 1:
    wait_for_completion(&test);
		break;
	case 2:
    complete_all(&test);
		break;
	}

	return 0;
}
