# Docker FTPS

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-ftps) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fftps) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fftps) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-ftps/dev.yml?branch=main)

[Docker Repository](https://hub.docker.com/r/bfren/ftps) - [bfren ecosystem](https://github.com/bfren/docker)

Comes with vsftpd installed and running in passive mode, with TLS support (self-signed certificates).

WinSCP config (for example):

```c
// do not choose SFTP, this is a completely different protocol
Protocol: FTP

// i.e. not 'plain' or 'implicit'
Encryption: TLS/SSL Explicit encryption

// choose either the IP or URI defined in docker-compose.yml
Host: BF_FTPS_EXTERNAL_IP or BF_FTPS_EXTERNAL_URI

// you need to open ports 990 and 18700-18710 as well - the
// connection begins on port 21 and is escalated to the others
Port: 21

// defined in docker-compose.yml
User name: BF_FTPS_VSFTPD_USER

// defined in docker-compose.yml
Password: BF_FTPS_VSFTPD_PASS
```

## Contents

* [Ports](#ports)
* [Volumes](#volumes)
* [Environment Variables](#environment-variables)
* [Licence / Copyright](#licence)

## Ports

* 21
* 990
* 18700-18710

## Volumes

| Volume   | Purpose                                                                                                                                                |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `/files` | Contains the files that can be accessed / written.                                                                                                     |
| `/ssl`   | Stores (self-signed) SSL certificates - if you symlink a PEM file called `server.pem` here with a valid SSL certificate, `vsftpd` will use it instead. |

## Environment Variables

| Variable                          | Values | Description                                                                                                                        | Default                                                    |
| --------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| `BF_FTPS_EXTERNAL_IP`             | string | The external IP of the server - required for passive mode (unless `BF_FTPS_EXTERNAL_URI` is set).                                  | *None* - **required** unless `BF_FTPS_EXTERNAL_URI` is set |
| `BF_FTPS_EXTERNAL_URI`            | string | The URI of the server - required for passive mode (unless `BF_FTPS_EXTERNAL_IP` is set).<br>If both are set this takes precedence. | *None* - **required** unless `BF_FTPS_EXTERNAL_IP` is set  |
| `BF_FTPS_SSL_BITS`                | string | The number of bits to use for the self-signed SSL certificate.                                                                     | 4096                                                       |
| `BF_FTPS_VSFTPD_USER`             | string | A user account will be created for connecting to the server.                                                                       | *None* - **required**                                      |
| `BF_FTPS_VSFTPD_PASS`             | string | The password to use for connecting to the server.                                                                                  | *None* - **required**                                      |
| `BF_FTPS_VSFTPD_UID`              | string | User ID with access rights to the `/files` directory.                                                                              | 1000                                                       |
| `BF_FTPS_VSFTPD_ENABLE_DEBUG_LOG` | 0 or 1 | Whether or not to enable all FTP commands and responses for vsftpd.                                                                | 0                                                          |
| `BF_FTPS_VSFTPD_WELCOME`          | string | Welcome message when people sign in to the server.                                                                                 | "Welcome to the FTPS server."                              |

## Licence

> [MIT](https://mit.bfren.dev/2021)

## Copyright

> Copyright (c) 2021-2025 [bfren](https://bfren.dev) (unless otherwise stated)
