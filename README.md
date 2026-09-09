# Patches
[![Run specs](https://github.com/rdytech/patches/actions/workflows/specs.yml/badge.svg)](https://github.com/rdytech/patches/actions/workflows/specs.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/39d142050017ffeb2564/maintainability)](https://codeclimate.com/repos/557f93b76956807f81000001/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/39d142050017ffeb2564/test_coverage)](https://codeclimate.com/repos/557f93b76956807f81000001/test_coverage)
[![Gem Version](https://badge.fury.io/rb/patches.svg)](https://badge.fury.io/rb/patches)

![patches](docs/patches.jpg)


A simple gem for one off tasks

## Version 2.0

Please note the breaking change release around deployment. See [docs/usage.md](docs/usage.md) for the full change.

TL;DR You need to manually declare the patches task to run in your deploy.rb

## Compatibility

This release changes no version constraint: the gemspec still requires only
`railties >= 3.2` and sets no Ruby floor, so anything that installed 3.6.2
installs 3.6.3. The table is what CI verifies, which is narrower than what the
gem permits - older Ruby and Rails are untested here, not blocked.

| | Rails 7.1 | Rails 7.2 | Rails 8.0 | Rails 8.1 |
|---|---|---|---|---|
| **Ruby 3.0** | ✅ | | | |
| **Ruby 3.1** | ✅ | ✅ | | |
| **Ruby 3.2** | ✅ | ✅ | ✅ | ✅ |
| **Ruby 3.3** | ✅ | ✅ | ✅ | ✅ |
| **Ruby 3.4** | | ✅ | ✅ | ✅ |

A blank cell is a pairing Rails itself does not support. Ruby 2.7 and Rails
6.1/7.0 are deliberately not exercised - they are well past upstream support -
though the gem still installs and, as of this release, passes on them.

### Sidekiq

Sidekiq is an **optional** integration, not a runtime dependency: Patches runs
each patch inline when Sidekiq is absent. Set `config.use_sidekiq = true` to run
them in the background - see [docs/usage.md](docs/usage.md).

The workers resolve their mixin at load time via `Patches.sidekiq_job_module`,
preferring `Sidekiq::Job` (the name Sidekiq has used since 6.3) and falling back
to `Sidekiq::Worker`, so older Sidekiq keeps working. CI covers each state a
consumer can be in:

| State | Covered by |
|---|---|
| Sidekiq not installed | A leg omitting the gem entirely, exercising the `defined?(Sidekiq)` guards |
| Installed, strict arguments on | Sidekiq 7.x and 8.x at their default (`:raise`) |
| Installed, strict arguments off | Sidekiq 7.x and 8.x with `Sidekiq.strict_args!(false)` |
| Older Sidekiq | A 6.5 leg, plus a spec covering the `Sidekiq::Worker` fallback |

### Running one combination locally

The Gemfile reads the same variables CI sets, so any cell above is reproducible.
Bundler re-evaluates the Gemfile on every invocation, so **export** them rather
than prefixing a single command — otherwise `bundle exec` silently resolves the
defaults and you test something other than what you intended:

```
export RAILS_VERSION="~> 8.0.0"

bundle install
bundle exec rspec
```

Without Sidekiq at all, which is what a consumer that does not use it gets:

```
export SIDEKIQ_VERSION=none

bundle install
bundle exec rspec --exclude-pattern "sidekiq/**/*_spec.rb"
```

With Sidekiq 7 and strict argument checking turned off:

```
export SIDEKIQ_VERSION="~> 7.0" SIDEKIQ_STRICT_ARGS=false

bundle install
bundle exec rspec
```

Rails 6.1 and 7.0 need two extra pins if you do want to check them, neither
caused by Patches — Rails <= 7.0 pins its sqlite3 adapter to `~> 1.4`, and Rails
< 7.1 predates `concurrent-ruby` 1.3.5 removing a `Logger` constant it relies
on:

```
export RAILS_VERSION="~> 6.1.0" \
       SQLITE3_VERSION="~> 1.4" \
       CONCURRENT_RUBY_VERSION="< 1.3.5"

bundle install
bundle exec rspec
```

`unset` the variables (or use a fresh shell) before running the default
combination again, and delete `test.db` when switching between them: the suite
creates `patches_patches` only when it is missing, so a database left by an
earlier run can mask ordering problems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'patches'
```
And then execute:

    $ bundle

Or install it yourself as:

    $ gem install patches

## Usage

see [docs/usage.md](docs/usage.md)

## Development

```
docker-compose build
docker-compose run app bundle exec rspec
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org/gems/patches).

## Contributing

1. Fork it ( https://github.com/rdytech/patches/fork )
2. Create your feature branch (`git checkout -b feature/my-feature-name`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request
