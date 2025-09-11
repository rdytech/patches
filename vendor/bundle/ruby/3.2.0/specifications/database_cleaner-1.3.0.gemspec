# -*- encoding: utf-8 -*-
# stub: database_cleaner 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "database_cleaner".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ben Mabey".freeze]
  s.date = "2014-05-24"
  s.description = "Strategies for cleaning databases.  Can be used to ensure a clean state for testing.".freeze
  s.email = "ben@benmabey.com".freeze
  s.extra_rdoc_files = ["LICENSE".freeze, "README.markdown".freeze, "TODO".freeze]
  s.files = ["LICENSE".freeze, "README.markdown".freeze, "TODO".freeze]
  s.homepage = "http://github.com/bmabey/database_cleaner".freeze
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Strategies for cleaning databases.  Can be used to ensure a clean state for testing.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 3

  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
  s.add_development_dependency(%q<jeweler>.freeze, [">= 0"])
  s.add_development_dependency(%q<json_pure>.freeze, [">= 0"])
  s.add_development_dependency(%q<activerecord>.freeze, [">= 0"])
  s.add_development_dependency(%q<datamapper>.freeze, [">= 0"])
  s.add_development_dependency(%q<dm-migrations>.freeze, [">= 0"])
  s.add_development_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
  s.add_development_dependency(%q<mongoid>.freeze, [">= 0"])
  s.add_development_dependency(%q<tzinfo>.freeze, [">= 0"])
  s.add_development_dependency(%q<mongo_ext>.freeze, [">= 0"])
  s.add_development_dependency(%q<bson_ext>.freeze, [">= 0"])
  s.add_development_dependency(%q<mongo_mapper>.freeze, [">= 0"])
  s.add_development_dependency(%q<couch_potato>.freeze, [">= 0"])
  s.add_development_dependency(%q<sequel>.freeze, ["~> 3.21.0"])
  s.add_development_dependency(%q<mysql>.freeze, ["~> 2.8.1"])
  s.add_development_dependency(%q<mysql2>.freeze, [">= 0"])
  s.add_development_dependency(%q<pg>.freeze, [">= 0"])
  s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
  s.add_development_dependency(%q<ohm>.freeze, ["~> 0.1.3"])
  s.add_development_dependency(%q<guard-rspec>.freeze, [">= 0"])
end
