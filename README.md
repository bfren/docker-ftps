# FTPS

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-ftps) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fftps) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fftps) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-ftps/dev.yml?branch=main)

[Docker Hub](https://hub.docker.com/r/bfren/ftps) - [Quay.io](https://quay.io/repository/bfren/ftps) - [bfren ecosystem](https://github.com/bfren/docker)

## Introduction

An FTP server that only accepts encrypted connections (FTPS - FTP over TLS), for devices and apps that can't use SFTP. It runs [vsftpd](https://security.appspot.com/vsftpd.html) with one user, kept inside `/files`, and creates a self-signed certificate if you don't provide one.

It is built on [Alpine + S6](https://github.com/bfren/docker-alpine-s6), with vsftpd from Alpine's packages.

## Quickstart

```yaml
services:
  ftps:
    image: quay.io/bfren/ftps:5.1
    restart: unless-stopped
    ports:
      - "0.0.0.0:21:21"
      - "0.0.0.0:18700-18710:18700-18710"
    environment:
      - BF_FTPS_EXTERNAL_URI=ftp.example.com
      - BF_FTPS_VSFTPD_USER=fred
      - BF_FTPS_VSFTPD_PASS=${FTPS_PASS}
    volumes:
      - ./v/files:/files
      - ./v/ssl:/ssl
```

Run `docker compose up -d`, then connect with an FTP client, e.g. in FileZilla or WinSCP:

| Setting    | Value                                                   |
| ---------- | ------------------------------------------------------- |
| Protocol   | FTP (not SFTP - that is a different protocol)           |
| Encryption | Explicit FTP over TLS (not plain or implicit)           |
| Host       | `ftp.example.com` - the address in `BF_FTPS_EXTERNAL_*` |
| Port       | `21`                                                    |
| User name  | `BF_FTPS_VSFTPD_USER`                                   |
| Password   | `BF_FTPS_VSFTPD_PASS`                                   |

Accept the certificate when the client asks - it is self-signed unless you provide your own.

## Features

* 🔐 Encryption required for logins and file transfers
* 📁 One user, kept inside `/files`
* 📜 Self-signed certificate created on first start, or use your own
* 🌐 Passive mode with a fixed port range, for firewalls and NAT
* 🩺 Health check that logs in and uploads a file
* 🧪 Built-in tests

## Tags

Images are published to Docker Hub (`bfren/ftps`) and Quay.io (`quay.io/bfren/ftps`) for `linux/amd64`, `linux/arm/v7` and `linux/arm64`, with vsftpd 3.0.5 on Alpine 3.24.

| Tag                    | Example              | Use when                                   |
| ---------------------- | -------------------- | ------------------------------------------ |
| `latest`               |                      | You always want the newest image           |
| `MAJOR`                | `5`                  | You want updates, but not breaking changes |
| `MINOR`                | `5.1`                | You want fixes only - **recommended**      |
| `VERSION`              | `5.1.15`             | You want to pin this image exactly         |
| `vsftpdX`, `vsftpdX.Y` | `vsftpd3.0`          | You want a vsftpd version                  |
| `vsftpdX.Y.Z`          | `vsftpd3.0.5`        | You want an exact vsftpd release           |
| `vsftpdX.Y.Z-VERSION`  | `vsftpd3.0.5-5.1.15` | You want to pin both                       |

## Configuration

### Ports

| Port          | Purpose                                                        |
| ------------- | -------------------------------------------------------------- |
| `21`          | FTP control connection - encrypted with explicit TLS           |
| `18700-18710` | Passive data connections (change with `BF_FTPS_VSFTPD_*_PORT`) |

Publish the whole passive range, with the same numbers on the host and in the container.

### Volumes

| Volume   | Purpose                                                                  |
| -------- | ------------------------------------------------------------------------ |
| `/files` | The user's files - owned by the user, who can't see anything outside it. |
| `/ssl`   | `vsftpd.pem` - the certificate and key (created if it doesn't exist).    |

### Environment Variables

| Variable                                 | Values      | Description                                                                                                                    | Default                       |
| ---------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------------------------- |
| `BF_FTPS_VSFTPD_USER`                    | string      | **Required.** The user name to log in with.                                                                                    |                               |
| `BF_FTPS_VSFTPD_PASS`                    | string      | **Required.** The user's password.                                                                                             |                               |
| `BF_FTPS_EXTERNAL_URI`                   | host name   | The address clients use - told to clients for passive connections. Takes priority over `BF_FTPS_EXTERNAL_IP`.                  |                               |
| `BF_FTPS_EXTERNAL_IP`                    | IP address  | The address clients use, if you don't have a host name. One of the two is required.                                            |                               |
| `BF_FTPS_VSFTPD_UID`                     | number      | The user's UID - set it to the owner of `/files` on the host.                                                                  | `1000`                        |
| `BF_FTPS_VSFTPD_MIN_PORT`                | port        | First port for passive data connections.                                                                                       | `18700`                       |
| `BF_FTPS_VSFTPD_MAX_PORT`                | port        | Last port for passive data connections.                                                                                        | `18710`                       |
| `BF_FTPS_VSFTPD_WELCOME`                 | text        | Message shown when users log in.                                                                                               | `Welcome to the FTPS server.` |
| `BF_FTPS_VSFTPD_ENABLE_DEBUG_LOG`        | `0`, `1`    | Log every FTP command and transfer to `docker logs`.                                                                           | `0`                           |
| `BF_FTPS_VSFTPD_ENABLE_PASV_PROMISCUOUS` | `0`, `1`    | Turn off vsftpd's check that data connections come from the same address as the login. Only for secure tunnels - leave it off. | `0`                           |
| `BF_FTPS_SSL_BITS`                       | number      | Key size for the self-signed certificate.                                                                                      | `4096`                        |
| `BF_FTPS_LFTP_VERIFY_CERT`               | `no`, `yes` | Whether the health check verifies the certificate - only `yes` with a trusted certificate.                                     | `no`                          |

See [Alpine + S6](https://github.com/bfren/docker-alpine-s6#environment-variables) for `BF_DEBUG`, `BF_TZ` and the other base image variables.

## How It Works

On every start:

1. The user, password and external address are checked - the container stops if any are missing.
2. The user is created (if it doesn't exist yet) with `/files` as its home, and given `/files`.
3. If `/ssl/vsftpd.pem` doesn't exist, a self-signed certificate valid for ten years is created there.
4. `vsftpd.conf` is generated, and vsftpd runs under S6. The container stops if it crashes.

Logins and file transfers must be encrypted, the user is kept inside `/files` (`chroot`), and anonymous logins are refused. Uploaded files are readable only by the user (`umask 077`).

In passive mode the client opens a second connection for each transfer, to a port in the passive range, at the address the server gives it - `BF_FTPS_EXTERNAL_URI` (looked up when vsftpd starts) or `BF_FTPS_EXTERNAL_IP`. That address must reach the server from the client's side.

The health check (every 30 seconds) logs in as the user with `lftp`, uploads a small file and deletes it.

### Using your own certificate

Put a PEM file containing both the certificate and its private key at `/ssl/vsftpd.pem`, then restart. Set `BF_FTPS_LFTP_VERIFY_CERT=yes` if the certificate is trusted for `127.0.0.1`.

## Testing

```sh
./test.sh   # builds the image and runs /test
./run.sh    # builds the image and opens a shell, with the ports published on 127.0.0.1
```

`/test` runs this image's tests alongside the base images' tests: the environment checks, creating the certificate, the generated `vsftpd.conf` and `lftp.conf`, and the installed vsftpd version.

## Troubleshooting

### The container stops straight after starting

Check `docker logs <container>` - `BF_FTPS_VSFTPD_USER`, `BF_FTPS_VSFTPD_PASS`, and `BF_FTPS_EXTERNAL_URI` or `BF_FTPS_EXTERNAL_IP` must all be set.

### Logging in works, but listing files times out

The passive connection can't get through. Check the whole port range is published and allowed by your firewall, and that `BF_FTPS_EXTERNAL_*` is the address clients use to reach the server.

### I changed the password but the old one still works

The user is only created once, so changes are ignored until the container is recreated (`docker compose up -d --force-recreate`).

### The client says the certificate isn't trusted

It is self-signed. Accept it, or use [your own certificate](#using-your-own-certificate).

## FAQs

### Can I have more than one user?

No - one user per container. Run another container (with different ports) for another user.

### What's the difference between FTPS and SFTP?

FTPS is FTP with TLS encryption. SFTP is a different protocol, part of SSH. This image only supports FTPS.

## Licence

> [MIT](https://mit.bfren.dev/2021)

## Copyright

> Copyright (c) 2021-2026 [bfren](https://bfren.dev) (unless otherwise stated)
