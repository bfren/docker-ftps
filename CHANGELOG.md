# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [6.0.3] - Unreleased

### Fixed

- Logins failed with `500 OOPS: setgid` in some user namespaces (e.g. Podman with `UserNS=auto`), because 6.0.2
  ran vsftpd's unprivileged process as `nobody` (uid and gid 65534), which they don't map. It now runs as a
  dedicated `vsftpd` user with low ids, which still can't reach your files.

## [6.0.2] - 2026-11-10

### Changed

- Base image updated to `bfren/alpine-s6` 7.0.2, which updates Nushell to 0.117.0 (your own Nushell scripts may
  need changes), keeps the container starting when `BF_TZ` cannot be set, and no longer hides `CURRENT_FILE` and
  `FILE_PWD` from services - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).

### Security

- vsftpd no longer runs its unprivileged process (`nopriv_user`) as the FTP user, who owns `/files` - it uses
  vsftpd's default unprivileged user, so the process that handles network input can't reach your files.
- The configuration no longer turns on TLS 1.0 (`ssl_tlsv1`) - TLS versions are left at vsftpd's defaults. SSL 2
  and 3 are still refused.

## [6.0.1] - 2026-11-06

### Changed

- Base image updated to `bfren/alpine-s6` 7.0.1, which moves to Alpine 3.24.4 (with security fixes) and rebuilds
  BusyBox, figlet and Nushell - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).

## [6.0.0] - 2026-11-05

### Changed

- **Breaking:** base image updated to `bfren/alpine-s6` 7.0.0 - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).
  `bf env set` must now run as root.
- Images are built and published by the shared `bfren/docker` build workflow (`build.yml`), replacing the separate
  `dev.yml` and `publish.yml` workflows.

[6.0.3]: https://github.com/bfren/docker-ftps/compare/v6.0.2...v6.0.3
[6.0.2]: https://github.com/bfren/docker-ftps/compare/v6.0.1...v6.0.2
[6.0.1]: https://github.com/bfren/docker-ftps/compare/v6.0.0...v6.0.1
[6.0.0]: https://github.com/bfren/docker-ftps/compare/v5.2.5...v6.0.0
