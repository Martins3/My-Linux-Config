# 观测

## grafana
```sh
# 验证: grafana 的默认刷新时间是 1 分钟的
for((i=0; i < 10000; i++)); do
  curl -d "test,tag=1111 time=12,this=$i" -X POST 'http://127.0.0.1:8428/write'
  sleep 1
done
```

初始化
```sh
cd ~/core
git clone https://github.com/VictoriaMetrics/VictoriaMetrics
cd  ~/core/VictoriaMetrics/deployment/docker
docker compose up -d
```
登录 127.0.0.1:3000

## 需要统计的
- 启动 qemu 次数
- 启动 shell 次数
- ls 次数
- nvim 次数

## page fault 次数

## 内存的碎片化程度

## buddy 的状态之类的

## kvm 的状态，利用 kvm_stat 长期监测

## io 和 网络流量，就是使用 sar 之类的观测就可以了

## 到底是谁在使用 shared memory

## 记录下一天共启动 qemu 多少次
