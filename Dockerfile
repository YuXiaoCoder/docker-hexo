FROM node:alpine

RUN \
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  apk update && apk upgrade && \
  npm config set registry https://registry.npm.taobao.org && \
  npm install -g --no-optional hexo-cli && \
  npm install -g --no-optional hexo-generator-sitemap && \
  npm install -g --no-optional hexo-generator-baidu-sitemap && \
  npm install -g --no-optional hexo-generator-search && \
  npm install -g --no-optional hexo-generator-searchdb && \
  npm install -g --no-optional hexo-generator-index && \
  npm install -g --no-optional hexo-generator-archive && \
  npm install -g --no-optional hexo-generator-tag && \
  npm install -g --no-optional hexo-generator-category && \
  npm install -g --no-optional hexo-tag-dplayer && \
  npm install -g --no-optional hexo-tag-aplayer && \
  npm install -g --no-optional hexo-deployer-rsync && \
  npm install -g --no-optional hexo-deployer-git && \
  rm -rf /var/cache/apk/*

WORKDIR /blog

VOLUME ["/blog/source", "/blog/themes", "/root/.ssh"]

EXPOSE 80

ADD entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]
