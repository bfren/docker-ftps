#!/bin/sh

# only fast-forward, so local work is kept
git pull --ff-only

if [ -n "${1-}" ] ; then
    git checkout ${1} && git pull --ff-only
fi
