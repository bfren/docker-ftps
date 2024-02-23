#!/bin/sh

IMAGE=ftps
VERSION=`cat VERSION`
TAG=${IMAGE}-test

docker buildx build \
    --load \
    --build-arg BF_IMAGE=${IMAGE} \
    --build-arg BF_VERSION=${VERSION} \
    -f Dockerfile \
    -t ${TAG} \
    . \
    && \
    docker run --entrypoint "/usr/bin/env" ${TAG} -i nu -c "use bf test ; test"
