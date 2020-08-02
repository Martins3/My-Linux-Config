#!/bin/bash

# 构建 docker 参考
# https://github.com/testcab/docker-yay/blob/master/Dockerfile


# 更多的 autojump :
#  https://github.com/gsamokovarov/jump
docker run -v `pwd`:/app --privileged --name mm -it yay bash

echo "`ls`:ls"
