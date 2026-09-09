# Patches
[![Run specs](https://github.com/rdytech/patches/actions/workflows/specs.yml/badge.svg)](https://github.com/rdytech/patches/actions/workflows/specs.yml)
[![Gem Version](https://badge.fury.io/rb/patches.svg)](https://badge.fury.io/rb/patches)

![patches](docs/patches.jpg)

A simple gem for one off tasks - the things that do not belong in a schema
migration. Back-filling a column, correcting bad data, kicking off a one-time
import: write it as a class, deploy it, and Patches runs it once and records
that it ran.

## Installation

Add the gem to your application's Gemfile:

```ruby
gem 'patches'
```

Then install the migration that records which patches have run:

```
bundle exec rake patches:install:migrations
bundle exec rake db:migrate
```

## Usage

Generate a patch:

```
bundle exec rails g patches:patch PreferenceUpdate
```

Fill in `run`:

```ruby
class PreferenceUpdate < Patches::Base
  def run
    User.where(preference: nil).update_all(preference: 'default')
  end
end
```

Run the pending ones - each patch runs once, and is recorded in
`patches_patches`:

```
bundle exec rake patches:run
```

`rake patches:pending` lists what has not run yet. Patches can run inline or in
the background via Sidekiq, across all tenants when you use Apartment, and
report to Slack. See [docs/usage.md](docs/usage.md) for configuration, tenants,
deployment and the Capistrano task.

## Compatibility

| | Minimum |
|---|---|
| Ruby | 3.2 |
| Rails | 7.2 |

Every combination the gemspec allows is verified on each push and pull request -
the floors and the matrix are the same set, which they were not before 4.0:

| | Rails 7.2 | Rails 8.0 | Rails 8.1 |
|---|---|---|---|
| **Ruby 3.2** | ✅ | ✅ | ✅ |
| **Ruby 3.3** | ✅ | ✅ | ✅ |
| **Ruby 3.4** | ✅ | ✅ | ✅ |
| **Ruby 4.0** | ✅ | ✅ | ✅ |

Ruby 4.0 is newer than all three Rails releases, so those cells record that
Patches is verified on it, not that Rails claims support for it.

### Sidekiq

Sidekiq is an **optional** integration, not a runtime dependency: Patches runs
each patch inline when Sidekiq is absent. Set `config.use_sidekiq = true` to run
them in the background - see [docs/usage.md](docs/usage.md).

The workers include `Sidekiq::Job`, so Sidekiq 6.3 or newer is required when the
integration is used - 6.2 and earlier predate that constant. CI covers each
state a consumer can be in:

| State | Covered by |
|---|---|
| Sidekiq not installed | A leg omitting the gem entirely, exercising the `defined?(Sidekiq)` guards |
| Installed, strict arguments on | Sidekiq 7.x and 8.x at their default (`:raise`) |
| Installed, strict arguments off | Sidekiq 7.x and 8.x with `Sidekiq.strict_args!(false)` |

### Slack

Slack notifications are optional and Patches does not install
`slack-notifier` - add `gem 'slack-notifier'` to your own Gemfile if you set
`config.use_slack`. CI runs a leg without it to keep that path honest.

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

## Deprecations

3.7.0 introduces no breaking changes. It announces what 4.0 is expected to
require, so the upgrade is uneventful. Each warning names its replacement and
goes through the gem's own deprecator, which a host application can silence or
redirect:

```ruby
Patches.deprecator.behavior = :silence  # or :raise, :log, a lambda...
```

| Deprecated | Replacement |
|---|---|
| Ruby older than 3.2, Rails older than 7.2 | Ruby 3.2+ and Rails 7.2+. 4.0 is expected to raise the gemspec floors to these, which are higher than the range CI verifies today |

Nothing is removed in this release, and the gemspec floors are unchanged, so
anything that installed 3.6.x installs 3.7.0.

## Development

In VS Code or Codespaces, open the repository in the dev container - it reuses
the `app` service from `docker-compose.yml`, so there is one definition of the
environment rather than two. Otherwise, from a shell:

```
docker compose build
docker compose run --rm app
```

The container's default command runs the specs. Any cell of the matrix above is
reproducible in it: the Ruby version is a build argument, and the gem versions
are passed through from your shell. The image is built with the default
versions, so a non-default cell has to install them first:

```
docker compose build --build-arg RUBY_VERSION=3.1

RAILS_VERSION="~> 7.1.0" docker compose run --rm app \
  sh -c 'bundle install && bundle exec rspec'

SIDEKIQ_VERSION=none docker compose run --rm app \
  sh -c 'bundle install && bundle exec rspec --exclude-pattern "sidekiq/**/*_spec.rb"'
```

Or without Docker, if you have the Ruby you want on your path:

```
bundle install
bundle exec rspec
```

To install this gem onto your local machine, run `bundle exec rake install`.

## Releasing

Releases are published by GitHub Actions from a `vX.Y.Z` tag — see
[RELEASING.md](RELEASING.md).

## Contributing

1. Fork it ( https://github.com/rdytech/patches/fork )
2. Create your feature branch (`git checkout -b feature/my-feature-name`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request against `develop`
