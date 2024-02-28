#include "internal.h"
#include <linux/rwsem.h>
#include <linux/delay.h>

static DECLARE_RWSEM(test);

// 如果是 down read ，up_write 不可以来解锁
// rwsem 存在一个有趣的调试 : rwsem_set_owner
int test_rwsem(int action)
{
	switch (action) {
	case 0:
		down_read(&test);
		break;
	case 1:
		down_write(&test);
		break;
	case 2:
		up_read(&test);
		break;
	case 3:
		up_write(&test);
		break;
	}

	return 0;
}
