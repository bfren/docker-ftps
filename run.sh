#!/bin/sh

VERSION=`cat VERSION`

git pull || exit 1
chmod +x run.sh

docker buildx build \
    --build-arg BF_IMAGE=ftps \
    --build-arg BF_VERSION=${VERSION} \
    -f Dockerfile \
    -t ftps-dev \
    .

docker run -it ftps-dev sh
