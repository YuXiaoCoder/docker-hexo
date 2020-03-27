FROM ubuntu:latest

# Standard set up Node
# https://github.com/nodejs/docker-node/blob/master/12/stretch/Dockerfile

ENV NODE_VERSION 12.16.1

RUN \
  CODE_NAME=$(cat /etc/apt/sources.list | grep -v '^#' | awk '{print $3}' | head -1) && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ ${CODE_NAME} main restricted universe multiverse" > /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ ${CODE_NAME}-security main restricted universe multiverse" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ ${CODE_NAME}-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ ${CODE_NAME}-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
  apt update && apt --yes --allow-unauthenticated dist-upgrade && \
  apt install --yes --allow-unauthenticated git rsync curl xz-utils && \
  curl -fsSLO --compressed https://npm.taobao.org/mirrors/node/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz && \
  tar -Jxf node-v${NODE_VERSION}-linux-x64.tar.xz -C /usr/local --strip-components=1 --no-same-owner && \
  rm -f node-v${NODE_VERSION}-linux-x64.tar.xz && \
  npm config set registry https://registry.npm.taobao.org && \
  npm install -g --no-optional hexo-cli && \
  mkdir -p /blog && hexo init /blog && cd /blog && npm --no-optional install && \
  npm install --no-optional hexo-generator-sitemap && \
  npm install --no-optional hexo-generator-baidu-sitemap && \
  npm install --no-optional hexo-generator-search && \
  npm install --no-optional hexo-generator-searchdb && \
  npm install --no-optional hexo-generator-feed && \
  npm install --no-optional hexo-generator-index && \
  npm install --no-optional hexo-generator-archive && \
  npm install --no-optional hexo-generator-tag && \
  npm install --no-optional hexo-generator-category && \
  npm install --no-optional hexo-tag-dplayer && \
  npm install --no-optional hexo-tag-aplayer && \
  npm install --no-optional hexo-deployer-rsync && \
  npm install --no-optional hexo-deployer-git && \
  echo "Host *" >> /etc/ssh/ssh_config && \
  echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
  echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config && \
  apt purge --yes --allow-unauthenticated curl xz-utils && \
  rm -rf /blog/themes/* /blog/source/* && \
  rm -rf /var/cache/apt/*.deb

WORKDIR /blog

ADD entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]
