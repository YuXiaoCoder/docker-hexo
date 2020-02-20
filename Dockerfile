FROM node:alpine

RUN \
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  apk update && apk upgrade && \
  apk add --virtual .build-deps git && \
  npm config set registry https://registry.npm.taobao.org && \
  npm install -g --no-optional hexo-cli && \
  mkdir -p /blog && hexo init /blog && cd /blog && npm install && \
  npm install --no-optional hexo-generator-sitemap && \
  npm install --no-optional hexo-generator-baidu-sitemap && \
  npm install --no-optional hexo-generator-search && \
  npm install --no-optional hexo-generator-searchdb && \
  npm install --no-optional hexo-generator-index && \
  npm install --no-optional hexo-generator-archive && \
  npm install --no-optional hexo-generator-tag && \
  npm install --no-optional hexo-generator-category && \
  npm install --no-optional hexo-tag-dplayer && \
  npm install --no-optional hexo-tag-aplayer && \
  npm install --no-optional hexo-deployer-rsync && \
  npm install --no-optional hexo-deployer-git && \
  apk del .build-deps && \
  rm -rf /blog/themes/* /blog/source/* && \
  rm -rf /var/cache/apk/*

WORKDIR /blog

VOLUME ["/blog/source", "/blog/themes", "/root/.ssh"]

EXPOSE 80

ADD entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]
