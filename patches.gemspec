# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'patches/version'

Gem::Specification.new do |spec|
  spec.name          = "patches"
  spec.version       = Patches::VERSION
  spec.authors       = ["John D'Agostino"]
  spec.email         = ["johnd@jobready.com.au"]

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency "railties", ">= 3.2"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.5"
  spec.add_development_dependency "rspec-rails", "~> 3.2.0"
  spec.add_development_dependency "capybara", "~> 2.3.0"
  spec.add_development_dependency "generator_spec", "~> 0.9.0"
  spec.add_development_dependency "factory_girl", "~> 4.5.0"
  spec.add_development_dependency "timecop", "~> 0.7.0"
  spec.add_development_dependency "database_cleaner", "~> 1.3.0"
end
