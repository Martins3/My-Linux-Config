/**
 * 1. 确定自己的 preemt level 是什么
 */

#include "internal.h"
int test_preempt(int action){
  pr_info("[martins3:%s:%d] %d\n", __FUNCTION__, __LINE__, action);
  return 0;
}
