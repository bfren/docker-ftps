# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[6.0.1]: https://github.com/bfren/docker-ftps/compare/v6.0.0...v6.0.1
[6.0.0]: https://github.com/bfren/docker-ftps/compare/v5.2.5...v6.0.0
