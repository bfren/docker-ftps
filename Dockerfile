FROM bfren/alpine-s6:alpineedge-2.2.12

EXPOSE 21 990 18700-18710

ENV \
    # the username to connect to the server
    FTPS_USER= \
    # the password to connect to the server
    FTPS_PASS= \
    # the external IP address of the server
    FTPS_EXTERNAL_IP= \
    # the external URI of the server (takes precedence over FTPS_EXTERNAL_IP - but you must use one or the other)
    FTPS_EXTERNAL_URI= \
    # the number of bits for the SSL certificate
    FTPS_SSL_BITS=4096 \
    # the welcome message when people sign in to the server
    FTPS_WELCOME="Welcome to the FTPS server."

COPY ./overlay /
COPY ./VSFTPD_BUILD /tmp/VERSION

RUN bf-install

VOLUME [ "/files", "/ssl" ]
