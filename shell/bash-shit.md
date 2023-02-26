# 记录下 bash 中让人抓狂内容

- 关键在于规则模糊
- 如果 shell 中有一部分都是错的，为什么还让继续执行


## 2

```sh
A=$@
```

调用的时候，A 将会是一个 string 而不是 array 了。

## 函数实际上是不支持返回值的
bash 实际上不支持函数返回的操作，其返回值只是表示错误的
set -e 之后，如果 function return 了非 0 ，那么认为是一个 command 失败，接着整个程序结束。

## [ ] 4

```sh
set -e
function b() {
  cat g
  cat g
  cat g
  cat g
  cat g
}

function a() {
  cat g || true

  b # 如果直接调用 b ，那么 b 中第一个就失败
  a=$(b) # 但是如果是这种调用方法，b 中失败可以继续
}

a
```
