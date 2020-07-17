# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'patches/version'

Gem::Specification.new do |spec|
  spec.name          = "patches"
  spec.version       = Patches::VERSION
  spec.authors       = ["JobReady"]
  spec.email         = ["ruby_gems@jobready.com.au"]

  spec.licenses    = ['MIT']
  spec.summary       = %q{A simple gem for one off tasks}
  spec.description   = %q{A simple gem for one off tasks for example database patches}
  spec.homepage      = "http://github.com/jobready/patches"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 3.2"
  spec.add_dependency "slack-notifier"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.5"
  spec.add_development_dependency "rspec-rails", "~> 4.0.0"
  spec.add_development_dependency "capybara", "~> 2.3.0"
  spec.add_development_dependency "generator_spec", "~> 0.9.0"
  spec.add_development_dependency "simplecov", "~> 0.10"
  spec.add_development_dependency "factory_girl", "~> 4.5.0"
  spec.add_development_dependency "timecop", "~> 0.7.0"
  spec.add_development_dependency "database_cleaner", "~> 1.3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sidekiq", "~> 3.4.1"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "byebug"
end
