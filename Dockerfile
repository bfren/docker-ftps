FROM ghcr.io/bfren/alpine-s6:alpine3.22-5.6.3

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-ftps"

ARG BF_IMAGE
ARG BF_PUBLISHING
ARG BF_VERSION

EXPOSE 21 990 18700-18710

COPY ./overlay /

ENV \
    # the external IP address of the server
    BF_FTPS_EXTERNAL_IP= \
    # the external URI of the server (takes precedence over FTPS_EXTERNAL_IP - but you must use one or the other)
    BF_FTPS_EXTERNAL_URI= \
    # the number of bits for the SSL certificate
    BF_FTPS_SSL_BITS=4096 \
    # min port number for data connections
    BF_FTPS_VSFTPD_MIN_PORT=18700 \
    # max port number for data connections
    BF_FTPS_VSFTPD_MAX_PORT=18710 \
    # the username to connect to the server
    BF_FTPS_VSFTPD_USER= \
    # the password to connect to the server
    BF_FTPS_VSFTPD_PASS= \
    # the welcome message when people sign in to the server
    BF_FTPS_VSFTPD_WELCOME="Welcome to the FTPS server." \
    # enable vsftpd debug logging of all FTP commands and responses
    BF_FTPS_VSFTPD_ENABLE_DEBUG_LOG=0 \
    # whether the LFTP client should verify the server certificate for the healthcheck
    # - only use 'yes' if you have a non-self-signed SSL certificate mapped to /ssl/vsftpd.pem
    # valid values are values 'yes' or 'no' (default)
    BF_FTPS_LFTP_VERIFY_CERT=no

RUN bf-install

VOLUME [ "/files", "/ssl" ]
