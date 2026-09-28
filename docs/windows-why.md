# 为什么开始使用 Windows 作为开发机

工作内容与 Linux 强相关，因此同时维护 Windows 和 Linux 两套环境会增加成本；但日常工作中
企业微信、远程接入和腾讯会议在 Linux 上长期缺少稳定方案，最终仍需要一台可直接使用的
Windows 开发机。

## 尝试过的方案

1. Windows 虚拟机：企业微信通知难以自然地融入物理机桌面。
2. 远程连接 Windows 物理机：没有找到体验稳定的 Linux RDP client。

## 当前仍有的限制

- PowerToys 的按键映射偶尔会被微信快捷键占用；相关讨论见
  [PowerToys issue #34345](https://github.com/microsoft/PowerToys/issues/34345)。
- Windows 原生 QEMU 的 GTK 前端不便测试。
- Markdown 和 Typst 的 Linux 桌面预览工作流需要重新适配。

## 收益

- 企业通信和会议软件可以直接使用。
- 可以直接复现和测试 Windows 问题，尤其是 Hyper-V 相关问题。
- dotfiles 中保留统一部署入口后，维护第二套环境的成本已经明显降低。
