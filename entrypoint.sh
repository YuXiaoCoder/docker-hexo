#!/bin/sh

if [[ -n "${GIT_NAME}" ]] && [[ -n "${GIT_EMAIL}" ]]; then
    git config --global user.name ${GIT_NAME}
    git config --global user.email ${GIT_EMAIL}
fi

if [[ "${MODE}" = "server" ]]; then
    if [[ -n "${PORT}" ]]; then
        exec /usr/local/bin/hexo server -p ${PORT} --draft
    else
        exec /usr/local/bin/hexo server -p 80 --draft
    fi
elif [[ "${MODE}" = "deploy" ]]; then
    set -- /usr/local/bin/hexo clean && /usr/local/bin/hexo deploy --generate
else
    exec $@
fi
