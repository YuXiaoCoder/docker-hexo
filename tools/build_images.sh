#!/bin/bash

# 当前脚本的绝对路径
SCRIPT=$(readlink -f $0)
CWD=$(dirname ${SCRIPT})

# Docker是否在运行
DOCKER_STATUS=$(systemctl is-active docker.service)

if [[ ${DOCKER_STATUS} != 'active' ]]; then
    echo -e "\033[1;31mError: Docker is not running.\033[0m"
    exit 1
fi

# 是否已有镜像docker-hexo
IMAGE_FLAG=$(docker images | awk '{print $1}' | grep '^docker-hexo')

if [[ ${IMAGE_FLAG} == 'docker-hexo' ]]; then
    docker ps -a | grep 'docker-hexo' | awk '{print $1}' | xargs -i -n 1 docker stop {}
    docker ps -a | grep 'docker-hexo' | awk '{print $1}' | xargs -i -n 1 docker rm {} 
    docker rmi docker-hexo
fi

# 构建镜像
docker build --no-cache --tag docker-hexo ${CWD}/../

