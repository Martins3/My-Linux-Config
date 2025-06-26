$(shell pkg-config --cflags --libs libaio) 没有


```txt
gcc aio.c -L/nix/store/x4gs2rwxlzncs4xhi7swnkfyx2qy089w-libaio-0.3.113/lib
/nix/store/8qmr9i8i5lgac3jyba331izf8j09ddsa-binutils-2.43.1/bin/ld: /tmp/ccRtXxri.o: in function
 `main.cold':
aio.c:(.text.unlikely+0x28): undefined reference to `io_destroy'
/nix/store/8qmr9i8i5lgac3jyba331izf8j09ddsa-binutils-2.43.1/bin/ld: /tmp/ccRtXxri.o: in function
 `main':
aio.c:(.text.startup+0x38): undefined reference to `io_setup'
/nix/store/8qmr9i8i5lgac3jyba331izf8j09ddsa-binutils-2.43.1/bin/ld: aio.c:(.text.startup+0x10d):
 undefined reference to `io_submit'
/nix/store/8qmr9i8i5lgac3jyba331izf8j09ddsa-binutils-2.43.1/bin/ld: aio.c:(.text.startup+0x174):
 undefined reference to `io_destroy'
/nix/store/8qmr9i8i5lgac3jyba331izf8j09ddsa-binutils-2.43.1/bin/ld: aio.c:(.text.startup+0x1d6):
 undefined reference to `io_getevents'
collect2: error: ld returned 1 exit status
```
解决办法居然是 -laio


## 总是在一起的
autoconf
automake
