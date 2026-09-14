# 为什么我开始使用 Windows 作为开发机

似乎真的浪费太多时间在这个环境问题的折腾上了。

首先，我的工作和 Linux 强相关，我不想使用 Windows 是很正常的，
因为这样我需要维护两套环境。此外，微软不断在操作系统中插入自己的私货，实在让人难以喜欢。
但是工作后，我在 Linux 上实在难以解决如下几个程序:

1. 企业微信
2. 远程登录
3. 腾讯会议

## 尝试的方案
1. windows 虚拟机 : 不知道如何解决企业微信通知的物理机
2. rdp 远程登录一个 windows 物理机: 没有找到好用的 rdp client

## windows 遇到的问题
- PowerToys 映射的快捷键有时无法工作，微信会劫持，后来询问 kimi 解决，找到 https://github.com/microsoft/PowerToys/issues/34345
没有 kimi 我也许永远都不知道怎么解决

## 引入的问题
1. QEMU 无法启动 gtk 无法测试
2. markdown 和 typst 预览无法使用

## 引入的好处

1. 可以直接测试各种 Windows 问题，尤其是 Hyper-V 相关的
