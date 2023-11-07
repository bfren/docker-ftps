#!/bin/sh

git reset --hard && git pull

if [ -n "${1-}" ] ; then
    git checkout ${1} && git pull
fi

chmod +x pull.sh run.sh
