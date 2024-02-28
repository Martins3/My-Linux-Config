#include "internal.h"
#include <linux/completion.h>

static DECLARE_COMPLETION(test);

// 如果是 down read ，up_write 不可以来解锁
// rwsem 存在一个有趣的调试 : rwsem_set_owner
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
