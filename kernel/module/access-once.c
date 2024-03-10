#include <asm-generic/rwonce.h>
#include <linux/printk.h>
#include <linux/delay.h>
#include "internal.h"

/**
 * 就 while 循环判断这种，编译器非常的智能，只要认为存在其他的地方修改代码，
 * 都不会优化掉的
 */
void test1(void);
void test2(void);
void test3(void);
void test4(void);
void test5(void);
void test6(void);

/**
 * 指令合并
 */
void test7(void);
void test8(void);

/**
 * 指令重拍
 */
void test9(void);
void test10(void);
void test11(void);

// dead
void test1(void)
{
	int test1 = 1;
	while (test1) {
		pr_info("martins3");
		msleep(1000);
	}
}

// dead
void test2(void)
{
	int test2 = 1;
	while (READ_ONCE(test2)) {
		pr_info("martins3");
	}
}

// ok
int access_once_test3 = 1;
void test3(void)
{
	while (READ_ONCE(access_once_test3)) {
		pr_info("martins3");
	}
}

// ok
static int access_once_test4 = 1;
void test4(void)
{
	while (READ_ONCE(access_once_test4)) {
		pr_info("martins3");
	}
}

// dead / ok
static int access_once_test5 = 1;
void test5(void)
{
	while (access_once_test5) {
		pr_info("martins3");
	}
}

// ok
int access_once_test6 = 1;
void test6(void)
{
	while (access_once_test6) {
		pr_info("martins3");
	}
}

// 会合并
int access_once_test7;
void test7(void)
{
	access_once_test7 = 1;
	access_once_test7 = 2;
	access_once_test7 = 3;
}

// 不会合并
void test8(void)
{
	WRITE_ONCE(access_once_test7, 1);
	WRITE_ONCE(access_once_test7, 2);
	WRITE_ONCE(access_once_test7, 3);
}

int access_once_test9 = 1;
int access_once_test10 = 1;

/**
 *
 * Dump of assembler code for function test9:
 *  0x00000000000001f0 <+0>:     endbr64
 *  0x00000000000001f4 <+4>:     call   0x1f9 <test9+9>
 *  0x00000000000001f9 <+9>:     movl   $0x2,0x0(%rip)        # 0x203 <test9+19>
 *  0x0000000000000203 <+19>:    movl   $0x3,0x0(%rip)        # 0x20d <test9+29>
 *  0x000000000000020d <+29>:    jmp    0x212
 **/

void test9(void)
{
	access_once_test9 = 0x2222;
	access_once_test10 = 0x2222;

	/* test_access_once(1); */

	/**
   * 0x00000000000001f0 <+0>:     endbr64
   * 0x00000000000001f4 <+4>:     call   0x1f9 <test9+9>
   * 0x00000000000001f9 <+9>:     movl   $0x2222,0x0(%rip)        # 0x203 <test9+19>
   * 0x0000000000000203 <+19>:    movl   $0x3333,0x0(%rip)        # 0x20d <test9+29>
   * 0x000000000000020d <+29>:    jmp    0x212
   */
	access_once_test9 = 0x3333;
	access_once_test10 = 0x2222;
}

void test10(void)
{
	access_once_test9 = 0x2222;
	access_once_test10 = 0x2222;
	/**
   * 0x0000000000000230 <+0>:     endbr64
   * 0x0000000000000234 <+4>:     call   0x239 <test10+9>
   * 0x0000000000000239 <+9>:     movl   $0x3333,0x0(%rip)        # 0x243 <test10+19>
   * 0x0000000000000243 <+19>:    movl   $0x2222,0x0(%rip)        # 0x24d <test10+29>
   * 0x000000000000024d <+29>:    jmp    0x252
   */
  // XXX 如果想要输出 0x3333 和 0x2222 ，这两个 WRITE_ONCE 都不可以省去，
  // 因为另外一个不会省去
	WRITE_ONCE(access_once_test9, 0x3333);
	/* access_once_test10 = 0x2222; */
	WRITE_ONCE(access_once_test10, 0x2222);
}

/**
 * XXX mb 的确可以防止指令重拍，但是 mb 和 READ_ONCE / WRITE_ONCE 是两个
 * 维度的问题，只是有时候效果非常类似。
 *
 * 0x0000000000000270 <+0>:     endbr64
 * 0x0000000000000274 <+4>:     call   0x279 <test11+9>
 * 0x0000000000000279 <+9>:     movl   $0x2222,0x0(%rip)        # 0x283 <test11+19>
 * 0x0000000000000283 <+19>:    movl   $0x2222,0x0(%rip)        # 0x28d <test11+29>
 * 0x000000000000028d <+29>:    lock addl $0x0,-0x4(%rsp)
 * 0x0000000000000293 <+35>:    movl   $0x3333,0x0(%rip)        # 0x29d <test11+45>
 * 0x000000000000029d <+45>:    movl   $0x2222,0x0(%rip)        # 0x2a7 <test11+55>
 * 0x00000000000002a7 <+55>:    jmp    0x2ac
 */
void test11(void)
{
	access_once_test9 = 0x2222;
	access_once_test10 = 0x2222;
  smp_mb();
	access_once_test9 = 0x3333;
	access_once_test10 = 0x2222;
}


int test_access_once(int action)
{
	switch (action) {
	case 0:
		// 否则增加 access_once_test5 会导致 test5 结果不同
		access_once_test5 = 0;
		break;
	case 1:
		test5();
		break;
	}
	return 0;
}
