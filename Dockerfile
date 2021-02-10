FROM bcgdesign/alpine-s6:alpine-3.13-1.3.1

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="FTPS" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

EXPOSE 21 990 18700-18710

ENV \
    # the external IP address of the server
    EXTERNAL_IP= \
    # the external URI of the server (takes precedence over EXTERNAL_IP - but you must use one or the other)
    EXTERNAL_URI= \
    # the number of bits for the SSL certificate
    SSL_BITS=4096

COPY ./VSFTPD_BUILD /tmp/VSFTPD_BUILD
RUN export VSFTPD_VERSION=$(cat /tmp/VSFTPD_BUILD) \
    && echo "VSFTPD v${VSFTPD_VERSION}" \
    && apk -U upgrade \
    && apk add \
        openssl \
        vsftpd=${VSFTPD_VERSION} \
    && rm -rf /var/cache/apk/* /etc/ssl/private

COPY ./overlay /

RUN ln -s /ssl /etc/ssl/private
VOLUME [ "/files", "/ssl" ]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "healthcheck" ]
