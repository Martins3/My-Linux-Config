# 为什么我要去折腾 Linux

这个问题需要分成两个部分回答:
1. 为什么是 Linux ;
2. 为什么要折腾。

## Linux

就目前来说，我勉强算是一个 Linux 内核工程师，但是成为 Linux 内核工程师总体来说
我刻意选择的结果。Linux 在我看来是一个有趣的项目:
1. 复杂，有挑战的乐趣[^1]。
2. 有用，几乎无处不在，从 Android 到数据中心，从通讯基站到超级计算机，从洗衣机到汽车。
3. 开源，你无需参加微软或者 Apple 的面试，只需要一个邮箱就可以参与内核开发。一分钱都用不付就可以定制自己的 Linux 内核。
4. 社区，我大年 30 都不回家，这里各个都是人才，说话又好听，超喜欢在里面的。

## 折腾
1. 看似慢，实则快。

有的人写代码不写单元测试，项目不配置 ci ，代码风格随意，重复的代码不做抽象等。
这些操作看似可以加快项目的推进速度，实际上最后会导致各种低级 bug 层出不穷，得不偿失。

折腾 Linux 操作也是类似的，看似折腾 neovim ，tmux 会浪费掉一些时间，但是如果你计划写
几十年的代码[^2]，平均下来这部分的开销很少。

2. [加快经常性事件](https://en.wikipedia.org/wiki/Amdahl%27s_law)。

如果一个事情你经常做，那么就应该想办法优化它的流程，最好是可以完全自动化。
各种商业软硬件都是考虑到大多数用户的需求，如果你恰好有一些特殊的需求无法被覆盖到，那么你可能会比较难受。

例如我有一个需求是定期拉取最新的 Linux 内核，然后使用上我的配置构建出来，开始的时候我还是手动操作，搞了
几次之后就把他变成了一个小脚本

3. 如何保证相同的错误不会犯两次。

手动操作存在引入错误的风险，因为人会困，会累，有情绪，会疏忽。
但是程序不会，如果程序执行错误，那么我们可以继续优化，让程序不断进化。

## 最后

但是不要舍本逐末了，为了酷炫而酷炫，我现在有点后悔将 coc.vim 替换掉了。


[^1]: 好吧，就我目前的水平而言，大多数时候是挑战的折磨。
[^2]: 我知道有人会说程序员是青春饭，如果你也是这么想的，你可以关掉页面。
[^3]: 参考本项目 scripts/systemd/sync-kernel.sh。

<script src="https://giscus.app/client.js"
        data-repo="Martins3/My-Linux-Config"
        data-repo-id="MDEwOlJlcG9zaXRvcnkyMTUwMDkyMDU="
        data-category="General"
        data-category-id="MDE4OkRpc2N1c3Npb25DYXRlZ29yeTMyODc0NjA5"
        data-mapping="pathname"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="light"
        data-lang="en"
        crossorigin="anonymous"
        async>
</script>

本站所有文章转发 **CSDN** 将按侵权追究法律责任，其它情况随意。
