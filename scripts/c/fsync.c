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

int main(int argc, char *argv[]) {
  int fd = open("/tmp/a.txt", O_RDWR | O_CREAT, 0644);
  if (write(fd, "hi", sizeof("hi")) < 0)
    goto err;

  if (fsync(fd) < 0)
    goto err;
  return EXIT_SUCCESS;
err:
  printf("failed: %s\n", strerror(errno));
  return EXIT_FAILURE;
}
