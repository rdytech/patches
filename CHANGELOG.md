# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

Converted to GitHub Actions for CI

## [3.6.2] - 2022-08-10

Fixes incorrect release - tag and published gem back in sync

## [3.6.1] - 2022-08-10
### Added
- Github actions to publish to Rubygems upon release

### Fixed
- Fix `patches:pending` rake task

## [3.6.0] - 2022-05-27

3.6.1 changes were incorrectly published as 3.6.0 but tagged as 3.6.1

### Added
- Added `notification_prefix` and `notification_suffix` to configuration options
- Linked to docs/usage.md in README

### Changed
- Refactored `Patches::Notifier`
- `Patches::Notifier.append_tenant_message` effectively replaced by `tenant_suffix`

## [3.5.0] - 2020-07-22
### Added
- Enable application version constraint support on `Patches::TenantWorker`

## [3.4.0] - 2020-07-22
### Added
- `Patches::TenantWorker` application version constraint forward compatibility

## [3.3.0] - 2020-07-20
### Added
- Application version constraints

## [3.2.0] - 2020-07-16
### Added
- Added `Patches::Worker` extra parameters to support forward compatibility with the upcoming releases

## [3.1.0] - 2019-11-25
### Fixed
- Gem compatibility with Apartment 2

## [3.0.1] - 2018-11-19
### Added
- Set icon_emoji of posted slack message to :dog:

## [3.0.0] - 2018-11-19
### Removed
- Hipchat is no longer supported

## [2.4.1] - 2018-09-19
### Changed
- Corrected gem ownership and authors.
### Added
- Changelog
- Dockerfile and BuildKite pipeline config

## [2.4.0] - 2018-09-17
### Added
- Added slack notification configurability
