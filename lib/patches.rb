require "patches/version"

module Patches
  def self.default_path
    Rails.root.join('db/patches/') if defined?(:Rails)
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

require "patches/base"
require "patches/engine" if defined?(Rails)
require "patches/patch"
require "patches/pending"
require "patches/runner"
require "patches/tenant_runner"
require "patches/concerns/file_downloader_config_concern"
require "patches/file_downloader"
require "patches/file_downloaders/s3_downloader"
require "patches/config"
require "patches/notifier"
require "patches/worker" if defined?(Sidekiq)
