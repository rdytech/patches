# -*- encoding: utf-8 -*-
# stub: sidekiq 3.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sidekiq".freeze
  s.version = "3.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mike Perham".freeze]
  s.date = "2015-06-19"
  s.description = "Simple, efficient background processing for Ruby".freeze
  s.email = ["mperham@gmail.com".freeze]
  s.executables = ["sidekiq".freeze, "sidekiqctl".freeze]
  s.files = ["bin/sidekiq".freeze, "bin/sidekiqctl".freeze]
  s.homepage = "http://sidekiq.org".freeze
  s.licenses = ["LGPL-3.0".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Simple, efficient background processing for Ruby".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<redis>.freeze, [">= 3.0.6"])
  s.add_runtime_dependency(%q<redis-namespace>.freeze, [">= 1.3.1"])
  s.add_runtime_dependency(%q<connection_pool>.freeze, [">= 2.1.1"])
  s.add_runtime_dependency(%q<celluloid>.freeze, ["~> 0.16.0"])
  s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
  s.add_development_dependency(%q<sinatra>.freeze, [">= 0"])
  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.3.3"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rails>.freeze, ["~> 4.1.1"])
  s.add_development_dependency(%q<coveralls>.freeze, [">= 0"])
end
