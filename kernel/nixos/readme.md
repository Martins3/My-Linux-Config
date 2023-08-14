# 如何方便的再 nixos 上构建 kvm 模块


## 问题 1 : 这样执行完成之后，存在如下的警告
```txt
exe "make -j32"
exe "make M=./arch/x86/kvm/  modules -j32"
```

```txt
[ 1446.603548] kvm: version magic '6.4.9-g5962edea824b SMP preempt mod_unload ' should
 be '6.4.9 SMP preempt mod_unload '
```
