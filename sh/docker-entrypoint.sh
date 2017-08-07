#!/bin/sh

echo "$@" | awk -F ' ' '{print $1}' | xargs -i git config --global user.name {}
echo "$@" | awk -F ' ' '{print $2}' | xargs -i git config --global user.email {}
if [ "$3" = 's' ] || [ "$3" = 'server' ]; then
    set -- /usr/local/bin/hexo server -p 80
elif [ "$3" = 'd' ] || [ "$3" = 'deploy' ]; then
    set -- /usr/local/bin/hexo clean && /usr/local/bin/hexo deploy --generate
fi

# Others
exec "$@"
