#include "internal.h"

static atomic_t a;
int test_atomic(int action)
{
	switch (action) {
	case 0:
		pr_info("[martins3:%s:%d] %d\n", __FUNCTION__, __LINE__,
			atomic_read(&a));
		/* atomic_set(&a, 1); */
		atomic_add_unless(&a, 100, 0);
		// 只有不等于 0 的时候才会增加 100
		pr_info("[martins3:%s:%d] %d\n", __FUNCTION__, __LINE__,
			atomic_read(&a));

		break;
	}
	return 0;
}
