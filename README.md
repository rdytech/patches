# Patches
![Specs Workflow](https://github.com/rdytech/usi/actions/workflows/specs.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/39d142050017ffeb2564/maintainability)](https://codeclimate.com/repos/557f93b76956807f81000001/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/39d142050017ffeb2564/test_coverage)](https://codeclimate.com/repos/557f93b76956807f81000001/test_coverage)
[![Gem Version](https://badge.fury.io/rb/patches.svg)](https://badge.fury.io/rb/patches)

![patches](docs/patches.jpg)


A simple gem for one off tasks

## Version 2.0

Please note the breaking change release around deployment. See [docs/usage.md](docs/usage.md) for the full change.

TL;DR You need to manually declare the patches task to run in your deploy.rb

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

1. Fork it ( https://github.com/jobready/patches/fork )
2. Create your feature branch (`git checkout -b feature/my-feature-name`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request
