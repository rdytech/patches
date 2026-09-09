require 'patches/deprecation'

Patches.warn_capistrano_support_removed_in_4_0

load File.expand_path("capistrano/tasks.rake", File.dirname(__FILE__))
