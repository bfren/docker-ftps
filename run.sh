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
        -e BF_FTPS_VSFTPD_ENABLE_DEBUG_LOG=1 \
        -p "127.0.0.1:21:21" \
        -p "127.0.0.1:990:990" \
        -p "127.0.0.1:18700-18710:18700-18710" \
        -v "$(pwd)/files:/files" \
        -v "$(pwd)/ssl:/ssl" \
        ftps-dev \
        sh
