## Docker-Hexo

### 起因

1. 每次更换电脑以后，为了写博客就必须去安装`Hexo`，这么繁琐的工作，不愿意重复花时间完成，故封装了`Docker`镜像。

### 使用方法

1. 构建镜像(耐心等待)：

```bash
# 方式1
docker build --no-cache -t docker-hexo https://github.com/YuXiaoCoder/docker-hexo.git#stable

# 方式2
cd docker-hexo/
docker build --no-cache --tag docker-hexo .
```

2. 设置环境变量：

```bash
echo 'export BlogRoot="/opt/blog"' >> /etc/profile
echo 'export BlogPort=80' >> /etc/profile
echo 'export GitHub_Name="YuXiaoCoder"' >> /etc/profile
echo 'export GitHub_Email="xiao.950901@gmail.com"' >> /etc/profile
source /etc/profile
```

3. 创建`Web`服务容器：

```bash
docker run -dit -p ${BlogPort}:80 --name "hexo-server" \
-v ${BlogRoot}/source:/blog/source \
-v ${BlogRoot}/themes:/blog/themes \
-v ${BlogRoot}/_config.yml:/blog/_config.yml \
--restart=always \
docker-hexo \
${GitHub_Name} \
${GitHub_Email} \
server
```

4. 创建部署容器：

```bash
docker run -d --name "hexo-deploy" \
-v ${BlogRoot}/source:/blog/source \
-v ${BlogRoot}/themes:/blog/themes \
-v ${BlogRoot}/_config.yml:/blog/_config.yml \
-v /root/.ssh:/root/.ssh \
docker-hexo \
${GitHub_Name} \
${GitHub_Email} \
deploy
```

5. 设置命令别名：

```bash
echo 'alias hexo="docker run -it --rm -v ${BlogRoot}/source:/blog/source -v ${BlogRoot}/themes:/blog/themes -v ${BlogRoot}/_config.yml:/blog/_config.yml docker-hexo /usr/local/bin/hexo"' >> /etc/profile
source /etc/profile
```

6. 创建新文章：

```bash
hexo new NAME
```

7. 更新内容后，重启`Web`服务容器：

```bash
docker restart hexo-server
```

8. 启动`Web`服务容器：

```bash
docker start hexo-server
```

9. 启动部署博客的容器：

```bash
docker start hexo-deploy
```

***

