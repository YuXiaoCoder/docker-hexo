#!/bin/bash

# Blog的根目录
echo 'export BlogRoot="/blog"' >> /etc/profile
echo 'export BlogPort=4000' >> /etc/profile
echo 'export GitHub_Name="YuXiaoCoder"' >> /etc/profile
echo 'export GitHub_Email="xiao.950901@gmail.com"' >> /etc/profile
source /etc/profile

# 创建运行容器
docker run -dit -p ${BlogPort}:80 --name "hexo-server" \
-v ${BlogRoot}/source:/blog/source \
-v ${BlogRoot}/themes:/blog/themes \
-v ${BlogRoot}/_config.yml:/blog/_config.yml \
-v /root/.ssh:/root/.ssh \
docker-hexo \
${GitHub_Name} \
${GitHub_Email} \
server

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
source /etc/bashrc

