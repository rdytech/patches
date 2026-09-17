# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.7.0] - 2026-09-10

Declares dependencies the gem always relied on, and announces what 4.0 is
expected to require. No public API changes and no version constraint moves, so
anything that installed 3.6.x installs this.

### Added
- Gem metadata (`source_code_uri`, `changelog_uri`, `bug_tracker_uri`,
  `documentation_uri`). None were declared, so rubygems.org kept showing values
  carried over from older releases - 3.6.3 still lists `source_code_uri` as
  `http://github.com/jobready/patches`, from before the org was renamed
- `activerecord` as an explicit runtime dependency, at the same `>= 3.2` floor
  as `railties` so nothing currently installable is excluded. `Patches::Patch`
  subclasses `ActiveRecord::Base` and `Patches::Base#execute` calls
  `ActiveRecord::Base.connection`, but only `railties` had been declared
- `Patches.deprecator`, a gem-owned `ActiveSupport::Deprecation` instance rather
  than the singleton Rails 7.1 deprecated and 8.0 removed. Host applications can
  silence or redirect it with `Patches.deprecator.behavior = :silence`
- A deprecation warning when `config.use_slack` is set: from 4.0 Patches will
  not depend on `slack-notifier`, so only applications using Slack carry it.
  Add `gem 'slack-notifier'` to your Gemfile to keep notifications working
- A deprecation warning on `require 'patches/capistrano'`. The Capistrano task
  is removed in 4.0; invoke `rake patches:run` from your deployment process
  instead. It remains opt-in and loads nothing unless a Capfile requires it
- Deprecation warnings for the two other things 4.0 is expected to require:
  Sidekiq 6.3 or newer, which is where `Sidekiq::Job` arrives, and Ruby 3.2 /
  Rails 7.2. Those floors are higher than the range CI verifies - Ruby 3.0 and
  Rails 7.1 still pass - so anyone below them hears about it a release ahead.
  The Ruby and Rails notice runs from a Rails initializer, after the
  application's own, so `Patches.deprecator.behavior` can silence it

### Changed
- The published gem carries only what a consumer needs - 27 files rather than
  42. `Dockerfile`, `docker-compose.yml`, `.devcontainer/`, `.github/`, `bin/`,
  `Rakefile`, `RELEASING.md` and a decorative image were being packaged. `lib`,
  the install migration, `docs/usage.md` and the top-level docs remain
- The development container works again. It was pinned to `ruby:2.3`, which
  cannot satisfy the current Gemfile, and had not been touched since 2018. The
  Ruby version is now a build argument and the gem versions are passed through
  from the shell, so any cell of the matrix in README.md is reproducible in it.
  A `.devcontainer/` referencing the same compose service comes with it, for
  VS Code and Codespaces

### Removed
- `.github/workflows/publish.yml`. It published on `release: published` using a
  `GEM_HOST_API_KEY`, had never run in the four years since it was added, and
  would now attempt a duplicate push if a GitHub Release were created after a
  tag. Releases come from `.github/workflows/release.yml` - see
  [RELEASING.md](RELEASING.md)

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
- A release workflow and `RELEASING.md`, both matching rdytech/superset-client:
  pushing a `v`-prefixed tag publishes to RubyGems through trusted publishing,
  and a tag not reachable from `develop` is refused. It also waits for the
  version to appear on RubyGems, so a release that does not land fails loudly -
  `3.6.1` was tagged and released on GitHub but never published, and nothing
  reported it
- CI now runs 17 Ruby/Rails combinations (Ruby 3.0-4.0 against Rails 7.1-8.1)
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

### Known issues
- The install migration now declares `ActiveRecord::Migration[5.0]`, and
  `ActiveRecord::Migration.[]` does not exist before Rails 5.0. A *fresh*
  install on Rails 4.2 or earlier therefore needs `patches_patches` created by
  hand - the table it wants is a `path` string, timestamps, and a unique index
  on `path`. Existing installs are unaffected, having already copied the
  migration into the host application. Those versions are far outside the range
  CI verifies, and the previous file could not be loaded by any Rails from 5.0
  on, so this trades an impossible install for an unlikely one

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
