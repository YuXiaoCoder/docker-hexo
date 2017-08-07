FROM centos:7.3.1611

ENV NodeJS_Version "6.11.2"
ENV TZ "Asia/Shanghai"

# 修正容器中的时间
RUN \cp -f /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone && rm -f /etc/yum.repos.d/*

COPY conf/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum makecache fast && yum update -y && yum install -y git

COPY src/node-v${NodeJS_Version}-linux-x64.tar.xz /opt/
# 安装Node.js并更换npm镜像
RUN \
tar -Jxf /opt/node-v${NodeJS_Version}-linux-x64.tar.xz -C /usr/local/ && \
ln -s /usr/local/node-v${NodeJS_Version}-linux-x64 /usr/local/node && \
ln -s /usr/local/node/bin/* /usr/local/bin/ && \
npm config set registry https://registry.npm.taobao.org && \
rm -f /opt/node-v${NodeJS_Version}-linux-x64.tar.xz

WORKDIR /blog

# 安装Hexo
RUN \
npm install -g --no-optional hexo-cli && \
ln -s /usr/local/node/bin/hexo /usr/local/bin/hexo && \
hexo init /blog && \
rm -rf /blog/themes/* && \
npm install --no-optional --save hexo-generator-sitemap && \
npm install --no-optional --save hexo-generator-feed && \
npm install --no-optional --save hexo-deployer-git && \
npm install --no-optional --save hexo-deployer-rsync && \
npm install --no-optional --save hexo-generator-index && \
npm install --no-optional --save hexo-generator-archive && \
npm install --no-optional --save hexo-generator-tag && \
npm install --no-optional --save hexo-tag-dplayer && \
npm install --no-optional --save hexo-tag-aplayer

# 挂载卷
#VOLUME ["/blog/source", "/blog/themes", "/blog/_config.yml", "/root/.ssh"]
VOLUME ["/blog/source", "/blog/themes", "/root/.ssh"]

# 开放端口
EXPOSE 80

# 添加脚本
COPY sh/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 764 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
