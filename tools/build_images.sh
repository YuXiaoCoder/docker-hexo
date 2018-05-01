#!/bin/bash

# 当前脚本的绝对路径
SCRIPT=$(readlink -f $0)
CWD=$(dirname ${SCRIPT})

# Docker是否在运行
Docker_Status=$(systemctl status docker | grep 'Active' | awk '{print $2}')

if [[ ${Docker_Status} != 'active' ]]; then
    echo -e "\033[1;31mError: Docker is not running.\033[0m"
    exit 1
fi

# 是否已有镜像docker-hexo
Image_Flag=$(docker images | awk '{print $1}' | grep '^docker-hexo')

if [[ ${Image_Flag} == 'docker-hexo' ]]; then
    docker ps -a | grep 'docker-hexo' | awk '{print $1}' | xargs -i -n 1 docker stop {}
    docker ps -a | grep 'docker-hexo' | awk '{print $1}' | xargs -i -n 1 docker rm {} 
    docker rmi docker-hexo
fi

# 构建镜像
docker build --tag docker-hexo ${CWD}/../

