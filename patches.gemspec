# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'patches/version'

Gem::Specification.new do |spec|
  spec.name          = "patches"
  spec.version       = Patches::VERSION
  spec.authors       = ["ReadyTech"]
  spec.email         = ["ruby_gems@readytech.io"]

  spec.licenses    = ['MIT']
  spec.summary       = %q{A simple gem for one off tasks}
  spec.description   = %q{A simple gem for one off tasks for example database patches}
  spec.homepage      = "https://github.com/rdytech/patches"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Floors stay where they are: raising a minimum can block an install that works
  # today, which is a major-version change. README.md records the range CI
  # verifies, and 4.0 will raise these to match.
  spec.add_dependency "railties", ">= 3.2"

  # Declared at the same floor as railties so nothing currently installable is
  # excluded. Patches::Patch subclasses ActiveRecord::Base and lib/patches/base.rb
  # calls ActiveRecord::Base.connection, but only railties had been declared.
  spec.add_dependency "activerecord", ">= 3.2"

  spec.add_dependency "slack-notifier"

  spec.add_development_dependency "bundler", "> 1.8"
  spec.add_development_dependency "rake", "> 10.0"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "simplecov", "~> 0.17", '< 0.18' # sonarscanner requires < 0.18
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"

  # rails, sqlite3, sidekiq and concurrent-ruby live in the Gemfile so CI can
  # vary them across the range documented in README.md. capybara, factory_girl,
  # timecop, generator_spec, byebug and database_cleaner were referenced by no
  # spec, and rspec-rails was never required, so plain rspec replaces it.
  # Sidekiq is an optional integration, not a runtime dependency, and the suite
  # is expected to pass without it installed.
end
