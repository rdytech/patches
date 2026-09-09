# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

Converted to GitHub Actions for CI

## [3.6.3] - 2026-09-09

Bug fixes only. No version constraint changes, no API changes and nothing
removed from the public interface, so anything that installed 3.6.2 installs
this. First step of a staged modernisation: declaring dependencies and adding
deprecations comes in 3.7.0, raising minimums in 4.0.0.

### Fixed
- Sidekiq 7 and 8 compatibility. Strict argument checking, enabled by default
  from Sidekiq 7, rejected the job arguments the workers enqueued:
  `patches:run` passed the runner class object itself and `application_version`
  used a symbol key, so enqueueing raised `ArgumentError: Job arguments to
  Patches::Worker must be native JSON types`. The task now enqueues the runner
  class name and the key is a string. The serialised payload is byte-identical
  to 3.6.2's - the class already reached Redis as `"Patches::Runner"` and the
  symbol key as `"application_version"` - so in-flight jobs and rolling deploys
  that mix old and new workers are unaffected
- The install migration inherited from a bare `ActiveRecord::Migration`, which
  Rails has refused since 5.0 with "Directly inheriting from
  ActiveRecord::Migration is not supported", so
  `rake patches:install:migrations && rake db:migrate` failed on every Rails
  since. It now declares `ActiveRecord::Migration[5.0]`, which Rails still
  supports through 8.1, so no minimum moves
- `Patches.default_path` guarded on `defined?(:Rails)`, which tests a symbol
  literal and is always true; outside Rails it raised `NameError` instead of
  returning nil

### Added
- Specs for the install migration, which shipped with no coverage at all, and
  for `Patches.sidekiq_job_module`, including its `Sidekiq::Worker` fallback
- CI now runs 14 Ruby/Rails combinations (Ruby 3.0-3.4 against Rails 7.1-8.1)
  in place of a single Ruby 2.7 cell, plus a leg for each Sidekiq state:
  absent, 6.5, and 7.x/8.x with strict arguments both on and off. Ruby 2.7 and
  Rails 6.1/7.0 are not exercised, being well past upstream support; they are
  untested rather than blocked, since no constraint changed. README.md records
  the verified range and how to check an older combination locally

### Changed
- The workers resolve their mixin through `Patches.sidekiq_job_module`, which
  prefers `Sidekiq::Job` (Sidekiq 6.3+) and falls back to `Sidekiq::Worker`, so
  no Sidekiq version loses support
- Development dependencies pruned to those actually used: `capybara`,
  `factory_girl`, `timecop`, `generator_spec`, `byebug` and `database_cleaner`
  were referenced by no spec, and `rspec-rails` was never required, so plain
  `rspec` replaces it. `rails`, `sqlite3`, `sidekiq` and `concurrent-ruby` moved
  to the Gemfile so CI can vary them; the stale `sidekiq ~> 3.4.1` pin is what
  hid the strict argument incompatibility, and it also held `json` at `~> 1.0`
- Sidekiq-dependent specs moved under `spec/sidekiq/` so the suite runs with the
  gem absent

### Removed
- `lib/generators/patches.rb`, a dead duplicate of the patch generator that
  wrote to `app/db/` from a template (`patch.erb`) that does not exist. Not
  reachable through Rails' generator lookup, so not part of the public interface

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
