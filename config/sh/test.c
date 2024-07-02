/* #include <x86intrin.h> */
#include <arm_neon.h>


/*
 * 1. 对于这个小文件 ，现在构建都有问题 : clang -target aarch64 test.c 不过报告的问题是 : <gnu/stubs-32.h>
 *   这个在 centos 上安装 yum install glibc-devel.i686 可以解决掉，但是 nixos 解决不掉
 *   - 使用 clang -target aarch64 -E test.c 可以看到这个时候是可以正常展开的
   2. 如果 clang -target aarch64-linux-gnu -nostdinc  test.c 的时候，那么就会出现和内核一样的问题
*  3. /nix/store/90c4rwfis305q63qw6w6f1lxh7031m0j-clang-14.0.6-lib/lib/clang/14.0.6/include/arm_neon.h
*
* 至此，可以确定，这个操作是 nixos 的技术失误。破案，结束!
*
* wrok around 的方法，在 clang -target aarch64 -E 的时候，获取到这些 header 的位置，然后将其手动拷贝 include 的位置中去，
*/

int main(int argc, char *argv[])
{
	return 0;
}
