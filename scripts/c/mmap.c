#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

const unsigned long PAGE_SIZE = 16 * 1024;

int main() {
  unsigned long size = 4000UL * 1024 * 1024;
  void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
                   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);

  if (ptr == MAP_FAILED) {
    printf("mmap failed: %s\n", strerror(errno));
    return 1;
  }

  for (unsigned long i = 0; i < size; i += PAGE_SIZE) {
    *((char *)(ptr + i)) = 'a';
  }
  sleep(10);

  if (munmap(ptr, size) == -1) {
    printf("munmap failed: %s\n", strerror(errno));
    return 1;
  }
}
