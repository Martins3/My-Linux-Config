#include <linux/wait_bit.h>
#include "internal.h"
/**
 * 等待 bit 被清理掉，如果本来就没设置 bit ，那么就会直接通过
 */

struct phone {
	unsigned long flags;
};

static struct phone my_phone;

enum PHONE_TYPE { PHONE_TYPE_XIAOMI, PHONE_TYPE_IPHONE };
int test_waitbit(int action)
{
	switch (action) {
	case 0:
		my_phone.flags = 1 << PHONE_TYPE_XIAOMI;
		wait_on_bit(&(my_phone.flags), PHONE_TYPE_XIAOMI,
			    TASK_UNINTERRUPTIBLE);
		break;
	case 1:
		wake_up_bit(&(my_phone.flags), PHONE_TYPE_XIAOMI);
		break;
	case 2:
		my_phone.flags &= ~(1 << PHONE_TYPE_XIAOMI);
		break;
	}
	return 0;
}
