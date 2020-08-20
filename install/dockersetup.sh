container_name=mi
image_name=archvim

# 创建 image
docker build -t ${image_name} .

# TODO 解决 container 内访问 kvm 的问题
# 创建 container
# docker run -it --name ${container_name}  -v /root/huxueshi/linux/:/home/martin/linux -d archvim
docker run -it --name ${container_name} -d archvim

# 进入名称
docker exec -it ${container_name} zsh

# 如果将 docker 部署在服务器上，使用此命令登入
alias x="ssh -t root@19.234.56.78 'docker exec -it wawa zsh'"
