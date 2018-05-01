#!/bin/bash

# 清除残留
sed -i '/BlogRoot/d' /etc/profile
sed -i '/BlogPort/d' /etc/profile
sed -i '/GitHub_Name/d' /etc/profile
sed -i '/GitHub_Email/d' /etc/profile
sed -i '/alias hexo/d' /etc/bashrc
sed -i '/alias npm/d' /etc/bashrc

# Blog的根目录
echo 'export BlogRoot="/opt/blog"' >> /etc/profile
echo 'export BlogPort=80' >> /etc/profile
echo 'export GitHub_Name="YuXiaoCoder"' >> /etc/profile
echo 'export GitHub_Email="xiao.950901@gmail.com"' >> /etc/profile
source /etc/profile

# 若存在已运行的Server容器，则删除
Server_Container=$(docker ps -a | grep 'hexo-server' | awk '{print $1}')

if [[ -n "${Server_Container}" ]]; then
    docker stop hexo-server
    docker rm hexo-server
fi

# 创建运行容器
docker run -dit -p ${BlogPort}:80 --name "hexo-server" \
-v ${BlogRoot}/source:/blog/source \
-v ${BlogRoot}/themes:/blog/themes \
-v ${BlogRoot}/_config.yml:/blog/_config.yml \
-v /root/.ssh:/root/.ssh \
--restart=always \
docker-hexo \
${GitHub_Name} \
${GitHub_Email} \
server

# 若存在已运行的Server容器，则删除
Deploy_Container=$(docker ps -a | grep 'hexo-deploy' | awk '{print $1}')

if [[ -n "${Deploy_Container}" ]]; then
    docker rm hexo-deploy
fi

# 创建部署容器
docker run -d --name "hexo-deploy" \
-v ${BlogRoot}/source:/blog/source \
-v ${BlogRoot}/themes:/blog/themes \
-v ${BlogRoot}/_config.yml:/blog/_config.yml \
-v /root/.ssh:/root/.ssh \
docker-hexo \
${GitHub_Name} \
${GitHub_Email} \
deploy

# 设置命令别名
echo 'alias hexo="docker run -it --rm -v ${BlogRoot}/source:/blog/source -v ${BlogRoot}/themes:/blog/themes -v ${BlogRoot}/_config.yml:/blog/_config.yml docker-hexo /usr/local/bin/hexo"' >> /etc/bashrc
echo 'alias npm="docker run -it --rm -v ${BlogRoot}/source:/blog/source -v ${BlogRoot}/themes:/blog/themes -v ${BlogRoot}/_config.yml:/blog/_config.yml docker-hexo /usr/local/bin/npm"' >> /etc/bashrc

