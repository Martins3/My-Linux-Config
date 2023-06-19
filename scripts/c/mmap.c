#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#include <fcntl.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

const unsigned long PAGE_SIZE = 4 * 1024;
unsigned long MAP_SIZE = 4000L * 1024 * 1024;

int get_file() {
  int fd = open("/mnt/huge", O_RDWR | O_CREAT, 0644);
  if (fd == -1)
    goto err;

  if (ftruncate(fd, MAP_SIZE) < 0)
    goto err;
  return fd;
err:
  printf("%s\n", strerror(errno));
  exit(1);
}

int main() {
  /* void *ptr = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE, */
  /*                  MAP_ANONYMOUS | MAP_SHARED, -1, 0); */

  /* void *ptr = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE, -1,
   * 0); */
  void *ptr =
      mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, get_file(), 0);
  if (ptr == MAP_FAILED)
    goto err;

  if (madvise(ptr, MAP_SIZE, MADV_HUGEPAGE) == -1)
    goto err;

  /* for (unsigned long i = 0; i < MAP_SIZE; i += PAGE_SIZE) { */
  /*   *((char *)(ptr + i)) = 'a'; */
  /* } */

  char m = '1';
  for (unsigned long i = 0; i < MAP_SIZE; i += PAGE_SIZE) {
    m += *((char *)(ptr + i));
  }
  printf("map finished %c\n", m);
  sleep(1000);

  if (munmap(ptr, MAP_SIZE) == -1)
    goto err;

  return 0;

err:
  printf("munmap failed: %s\n", strerror(errno));
  return 1;
}
