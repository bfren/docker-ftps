#!/bin/sh

IMAGE=`cat VERSION`

docker buildx build \
    --load \
    --no-cache \
    --progress plain \
    --build-arg BF_IMAGE=ftps \
    --build-arg BF_VERSION=${IMAGE} \
    -f Dockerfile \
    -t ftps-dev \
    . \
    && \
    docker run -it \
        -e BF_DEBUG=1 \
        -e BF_FTPS_EXTERNAL_IP=127.0.0.1 \
        -e BF_FTPS_VSFTPD_USER=foo \
        -e BF_FTPS_VSFTPD_PASS=bar \
        -p "127.0.0.1:5353:53/udp" \
        ftps-dev \
        sh
