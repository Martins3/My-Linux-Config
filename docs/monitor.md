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
cd ~
git clone https://github.com/VictoriaMetrics/VictoriaMetrics
cd  ~/core/VictoriaMetrics/deployment/docker
docker compose up -d
docker compose down # 删除
```
登录 127.0.0.1:3000

## 需要统计的
- 启动 qemu 次数
- 启动 shell 次数
- ls 次数
- nvim 次数

## 机箱温度

## page fault
