## Docker-Hexo

### 起因

+ 每次更换电脑以后，为了写博客就必须去安装`Hexo`，为避免繁琐的步骤，故封装了`Docker`镜像。

### 功能

+ [x] 支持本地预览
+ [x] 支持本地部署
+ [x] 支持远程部署

### 使用方法

#### 构建镜像

+ 本地构建镜像, 先`clone`仓库到本地, 再构建镜像:

```bash
git clone https://github.com/YuXiaoCoder/docker-hexo.git
cd docker-hexo/
docker build --no-cache --tag docker-hexo:1.0 .
```

#### 预览博客

+ 此容器用于预览博客，类似`hexo server`，可指定端口运行:

+ 创建`Server`容器：

```bash
# 将本机/blog根目录挂载到容器中

# 默认端口为80
docker run -d \
  --net host \
  -e MODE="server" \
  --restart=always \
  --name "hexo-server" \
  -v /blog/source:/blog/source \
  -v /blog/themes:/blog/themes \
  -v /blog/scaffolds:/blog/scaffolds \
  -v /blog/_config.yml:/blog/_config.yml \
  docker-hexo:1.0

# 指定端口运行
docker run -d \
  --net host \
  -e MODE="server" \
  -e PORT=4000 \
  --restart=always \
  --name "hexo-server" \
  -v /blog/source:/blog/source \
  -v /blog/themes:/blog/themes \
  -v /blog/scaffolds:/blog/scaffolds \
  -v /blog/_config.yml:/blog/_config.yml \
  docker-hexo:1.0
```

+ 更新内容后，若发现内容未自动更新，可尝试重启容器:

```bash
docker restart hexo-server
```

#### 部署博客

+ 此容器用于部署博客，支持`rsync`和`git`，使用`git`时，需要传入`NAME`和`EMAIL`:

+ 创建`Deploy`容器：

```bash
# rsync
docker run -d \
  --net host \
  -e MODE="deploy" \
  --name "hexo-deploy" \
  -v /root/.ssh:/root/.ssh \
  -v /blog/source:/blog/source \
  -v /blog/themes:/blog/themes \
  -v /blog/scaffolds:/blog/scaffolds \
  -v /blog/_config.yml:/blog/_config.yml \
  docker-hexo:1.0

# git
docker run -d \
  --net host \
  -e MODE="deploy" \
  -e GIT_NAME="{{NAME}}" \
  -e GIT_EMAIL="{{EMAIL}}" \
  --name "hexo-deploy" \
  -v /root/.ssh:/root/.ssh \
  -v /blog/source:/blog/source \
  -v /blog/themes:/blog/themes \
  -v /blog/scaffolds:/blog/scaffolds \
  -v /blog/_config.yml:/blog/_config.yml \
  docker-hexo:1.0
```

+ 更新博客后，预览检查无误后，部署博客:

```bash
docker start hexo-deploy
```

### 设置命令别名

+ 由于封装了`docker-hexo`镜像，导致我们物理机中没有`hexo`命令，命令别名的目的就在于让我们更方便的使用`hexo`命令。
+ 此命令实际上是创建了一个一次性的`Docker`容器。

```bash
echo 'alias hexo="docker run --rm -v /blog/source:/blog/source -v /blog/themes:/blog/themes -v /blog/scaffolds:/blog/scaffolds -v /blog/_config.yml:/blog/_config.yml docker-hexo:1.0 hexo"' >> /etc/profile
source /etc/profile
```

***
