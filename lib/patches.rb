# railties and activerecord are hard dependencies, and the engine, the install
# migration and Patches.default_path all assume a Rails application. The gem
# used to guard on `defined?(Rails)` as though Rails were optional; one of those
# guards read `defined?(:Rails)`, which is always truthy, and went unnoticed for
# years - nobody was running this outside Rails.
require 'rails'

require "patches/version"

module Patches
  def self.default_path
    Rails.root.join('db/patches/')
  end

  def self.class_name(path)
    match = path.match(/\d+_(.+?)\.rb/)
    match[1].camelcase if match
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(log)
    @logger = log
  end
end

require "patches/deprecation"
require "patches/base"
require "patches/config"
require "patches/tenant_run_concern"
require "patches/application_version_validation"
require "patches/tenant_worker" if defined?(Sidekiq)
require "patches/engine"
require "patches/patch"
require "patches/pending"
require "patches/runner"
require "patches/tenant_runner"
require "patches/notifier"
require "patches/worker" if defined?(Sidekiq)
