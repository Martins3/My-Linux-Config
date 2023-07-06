#include <errno.h>
#include <fcntl.h> /* For O_* constants */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h> /* For mode constants */
#include <unistd.h>

// 10G 大小
#define MAP_SIZE (10000UL * 1024 * 1024)
int main(int argc, char *argv[]) {
  int fd;
  void *result;
  char wait;

  fd = shm_open("shm1", O_RDWR | O_CREAT, 0644);
  if (fd < 0) {
    printf("shm_open failed\n");
    exit(1);
  }

  if (ftruncate(fd, MAP_SIZE) < 0) {
    printf("ftruncate failed\n");
    exit(1);
  }

  result = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (result == MAP_FAILED) {
    printf("mmap failed: %s\n", strerror(errno));
    return 1;
  }
  memset(result, 0, MAP_SIZE);
  if (result == MAP_FAILED) {
    printf("mapped failed\n");
    exit(1);
  }
  scanf("%c", &wait);

  while (true)
    sleep(1);
}
