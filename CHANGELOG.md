# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Generate a random string to be used for the VM's serial.

### Changed

- General tidy in preparation for cluster creation.
- Enable HA masters (3).
- Bump `glitchcrab/terraform-module-proxmox-instance` to 1.6.0
- Do not power on nodes after creation.

## [0.1.0] - 2022-12-19

- completely rework resources for PXE booting with Sidero.

[Unreleased]: https://github.com/a7d-corp/homelab-k8s-cluster-room101-a7d-mc/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/a7d-corp/homelab-k8s-cluster-room101-a7d-mc/releases/tag/v0.1.0
