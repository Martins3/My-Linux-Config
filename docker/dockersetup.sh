container_name=mi
image_name=archvim

# 创建 image
docker build -t ${image_name} .

# 创建 container
# docker run -it --name ${container_name}  -v /root/huxueshi/linux/:/home/martin/linux -d archvim
docker run -it --name ${container_name} -d archvim

# 进入名称
docker exec -it ${container_name} zsh
