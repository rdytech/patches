require "patches/version"

module Patches
  def self.default_path
    Rails.root.join('db/patches/') if defined?(:Rails)
  end
end

require "patches/engine"
require "patches/patch"
require "patches/pending"
require "patches/runner"
