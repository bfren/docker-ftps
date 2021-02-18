# Docker FTPS

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bencgreen/docker-ftps) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-ftps/build-dev?label=github) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/ftps?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/ftps?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/ftps/latest?label=size)

[Docker Repository](https://hub.docker.com/r/bcgdesign/ftps) - [bcg|design ecosystem](https://github.com/bencgreen/docker)

Comes with vsftpd installed and running in passive mode, with TLS support (self-signed certificates).

## Contents

* [Ports](#ports)
* [Volumes](#volumes)
* [Environment Variables](#environment-variables)
* [Authors / Licence / Copyright](#authors)

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

| Variable            | Values | Description                                                                                                                     | Default                                                 |
| ------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `FTPS_USER`          | string | The username to use for connecting to the server.                                                                               | *None* - **required**                                   |
| `FTPS_PASS`          | string | The password to use for connecting to the server.                                                                               | *None* - **required**                                   |
| `FTPS_EXTERNAL_IP`  | string | The external IP of the server - required for passive mode (unless `FTPS_EXTERNAL_URI` is set).                                  | *None* - **required** unless `FTPS_EXTERNAL_URI` is set |
| `FTPS_EXTERNAL_URI` | string | The URI of the server - required for passive mode (unless `FTPS_EXTERNAL_IP` is set).<br>If both are set this takes precedence. | *None* - **required** unless `FTPS_EXTERNAL_IP` is set  |
| `FTPS_SSL_BITS`     | string | The number of bits to use for the self-signed SSL certificate.                                                                  | 4096                                                    |
| `FTPS_WELCOME`      | string | Welcome message when people sign in to the server.                                                                              | "Welcome to the FTPS server."                           |

## Authors

* [Ben Green](https://github.com/bencgreen)

## License

> MIT

## Copyright

> Copyright (c) 2021 Ben Green <https://bcgdesign.com>
> Unless otherwise stated
