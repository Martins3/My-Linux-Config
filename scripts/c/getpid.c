#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main(void) {
  printf("%ld-%ld", (long)getpid(), (long)getppid());
  return 0;
}
