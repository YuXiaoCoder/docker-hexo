FROM centos:7.5.1804

MAINTAINER YuXiao

ENV NODEJS_VERSION "8.11.3"
ENV TZ "Asia/Shanghai"

RUN \cp -f /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN rm -f /etc/yum.repos.d/*
COPY conf/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum makecache fast && \
yum update -y && \
yum install -y git rsync wget

# Install Node.js
RUN \
wget https://npm.taobao.org/mirrors/node/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.xz -O node.txz && \
mkdir -p /usr/local/node/ && \
tar -Jxf node.txz --strip-components=1 -C /usr/local/node/ && \
ln -s /usr/local/node/bin/* /usr/local/bin/ && \
npm config set registry https://registry.npm.taobao.org && \
rm -f node.txz

WORKDIR /blog

# Install Hexo
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

VOLUME ["/blog/source", "/blog/themes", "/root/.ssh"]

EXPOSE 80

COPY sh/entrypoint.sh /entrypoint.sh
RUN \
chmod 775 /entrypoint.sh && \
yum clean all

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

