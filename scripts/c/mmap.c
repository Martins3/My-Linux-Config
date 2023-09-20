#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#include <fcntl.h>
#include <stdbool.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

const unsigned long PAGE_SIZE = 4 * 1024;
unsigned long MAP_SIZE = 4000L * 1024 * 1024;

#define MAPPING_PROT PROT_READ | PROT_WRITE

int get_file() {
  int fd;
  /* fd = open("/dev/hugepages/", O_RDWR | O_CREAT, 0644); */
  fd = open("/home/martins3/qemu.ram", O_RDWR | O_CREAT, 0644);
  /* fd = open("/root/hack/qemu.ram", O_RDWR | O_CREAT, 0644); */
  /* fd = open("/dev/shm/x", O_RDWR | O_CREAT, 0644); */
  if (fd == -1)
    goto err;

  if (ftruncate(fd, MAP_SIZE) < 0)
    goto err;
  return fd;
err:
  printf("%s\n", strerror(errno));
  exit(1);
}

void *copy_files() {
  void *ptr = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
                   MAP_ANONYMOUS | MAP_SHARED, -1, 0);
  size_t size = 0;

  if (ptr == MAP_FAILED)
    goto err;

  char m = '1';
  for (unsigned long i = 0; i < MAP_SIZE; i += PAGE_SIZE) {
    *((char *)(ptr + i)) = m;
  }

  int fd = get_file();
  // TODO 调查一下，为什么 read 循环多少次就会被打断一次
  // 读一个 8G 文件必须使用 while
  while (true) {
    sleep(1);
    lseek(fd, 0, SEEK_SET);
    while (read(fd, ptr, MAP_SIZE) > 0)
      ;
    sleep(1);

    // TODO write 这个停顿真烦人，每次的最多写 7ffff000
    while (true) {
      while (read(fd, ptr, MAP_SIZE) > 0)
        ;
      if (lseek(fd, 0, SEEK_SET) < 0)
        goto err;
      sleep(1);
    }

    printf("[martins3:%s:%d] size=%lx\n", __FUNCTION__, __LINE__, size);
  }
  return ptr;

err:
  printf("%s\n", strerror(errno));
  exit(1);
}

void *mmap_region() {
  /* void *ptr = mmap(NULL, MAP_SIZE, MAPPING_PROT, MAP_ANONYMOUS | MAP_SHARED, -1, 0); */
  // void *ptr = mmap(NULL, MAP_SIZE, MAPPING_PROT, MAP_ANONYMOUS | MAP_PRIVATE, 1, 0);
  // 这两个都是产生 page cache
  void *ptr = mmap(NULL, MAP_SIZE, MAPPING_PROT, MAP_SHARED, get_file(), 0);
  // void *ptr = mmap(NULL, MAP_SIZE, MAPPING_PROT, MAP_PRIVATE, get_file(), 0);
  if (ptr == MAP_FAILED)
    goto err;

  return ptr;
err:
  printf("%s\n", strerror(errno));
  exit(1);
}

int main() {
  /* void *ptr = copy_files(); */
  void *ptr = mmap_region();

  /* if (madvise(ptr, MAP_SIZE, MADV_HUGEPAGE) == -1) */
  /*   goto err; */

  if (madvise(ptr, MAP_SIZE, MADV_RANDOM) == -1)
    goto err;

  char m = '1';
  for (unsigned long i = 0; i < MAP_SIZE; i += PAGE_SIZE) {
    *((char *)(ptr + i)) = m;
  }
  printf("good\n");

  while (1) {
    for (unsigned long i = 0; i < MAP_SIZE; i += PAGE_SIZE) {
      m += *((char *)(ptr + i));
    }
    printf("loop %c\n", m);
  }
  sleep(1000);

  if (munmap(ptr, MAP_SIZE) == -1)
    goto err;

  return 0;

err:
  printf("munmap failed: %s\n", strerror(errno));
  return 1;
}
