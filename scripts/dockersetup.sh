#!/bin/bash
set -e

container_name=loongson
image_name=ubuntu20-nvim
docker_file=ubuntu20/Dockerfile

while getopts ":ci" opt
do
  case $opt in
  c) docker container stop ${container_name} && docker container rm ${container_name} ;;
  i) docker image rm ${image_name} ;;
  * )  echo -e "\n  Option does not exist : OPTARG\n"
    usage; exit 1   ;;
  esac    # --- end of case ---
done
shift $((OPTIND-1))

# 创建 image
docker build --network=host --tag ${image_name} - < ${docker_file}

# 创建 container
# docker run -it --name ${container_name}  -v /root/huxueshi/linux/:/home/martin/linux -d archvim
docker run -t --network=host -it --name ${container_name} -d ${image_name}

# 进入
docker exec -it ${container_name} /bin/bash

# 如果将 docker 部署在服务器上，使用此命令登入
# alias x="ssh -t root@12.34.56.78 'docker exec -it wawa zsh'"
