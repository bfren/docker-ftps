FROM bcgdesign/alpine-s6:alpine-3.13-1.3.0

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="FTPS" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

EXPOSE 21 990 18700-18710

ENV \
    # the external IP address of the server
    EXTERNAL_IP= \
    # the number of bits for the SSL certificate
    SSL_BITS=4096

COPY ./VSFTPD_BUILD /tmp/VSFTPD_BUILD
ARG GOMPLATE_VERSION=3.8.0-r0
RUN export VSFTPD_VERSION=$(cat /tmp/VSFTPD_BUILD) \
    && echo "VSFTPD v${VSFTPD_VERSION}" \
    && apk -U upgrade \
    && apk add \
        gomplate=${GOMPLATE_VERSION} \
        openssl \
        vsftpd=${VSFTPD_VERSION} \
    && rm -rf /var/cache/apk/*

COPY ./overlay /

VOLUME [ "/files", "/etc/ssl" ]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "healthcheck" ]
