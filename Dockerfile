# 基础镜像
FROM centos:7.4.1708

# 维护者信息
MAINTAINER YuXiao

# 设置变量
ENV NodeJS_Version "8.11.1"
ENV TZ "Asia/Shanghai"

# 修正容器中的时间
RUN \cp -f /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# 更换源并安装依赖
RUN rm -f /etc/yum.repos.d/*
COPY conf/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum makecache fast && yum update -y && yum install -y git

# 安装Node.js并更换npm镜像源
COPY src/node-v${NodeJS_Version}-linux-x64.tar.xz /opt/
RUN \
tar -Jxf /opt/node-v${NodeJS_Version}-linux-x64.tar.xz -C /usr/local/ && \
ln -s /usr/local/node-v${NodeJS_Version}-linux-x64 /usr/local/node && \
ln -s /usr/local/node/bin/* /usr/local/bin/ && \
npm config set registry https://registry.npm.taobao.org && \
rm -f /opt/node-v${NodeJS_Version}-linux-x64.tar.xz

# 工作目录
WORKDIR /blog

# 安装Hexo
RUN \
npm install -g --no-optional hexo-cli && \
ln -s /usr/local/node/bin/hexo /usr/local/bin/hexo && \
hexo init /blog && \
rm -rf /blog/themes/* /blog/source/* && \
npm install --no-optional --save hexo-generator-sitemap && \
npm install --no-optional --save hexo-generator-feed && \
npm install --no-optional --save hexo-generator-search && \
npm install --no-optional --save hexo-generator-searchdb && \
npm install --no-optional --save hexo-generator-index && \
npm install --no-optional --save hexo-generator-archive && \
npm install --no-optional --save hexo-generator-tag && \
npm install --no-optional --save hexo-tag-dplayer && \
npm install --no-optional --save hexo-deployer-rsync && \
npm install --no-optional --save hexo-deployer-git && \
npm install --no-optional --save hexo-tag-aplayer

# 挂载卷
VOLUME ["/blog/source", "/blog/themes", "/root/.ssh"]

# 开放端口
EXPOSE 80

# 添加脚本
COPY sh/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 764 /docker-entrypoint.sh

# 容器启动时执行脚本
ENTRYPOINT ["/docker-entrypoint.sh"]

