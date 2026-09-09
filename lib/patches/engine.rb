require 'rails/engine'

module Patches
  class Engine < Rails::Engine
    isolate_namespace Patches

    # After the application's own initializers, so that a host which sets
    # Patches.deprecator.behavior in config/initializers can actually silence
    # this. Warning at require time - which happens during Bundler.require,
    # before any initializer - meant the documented mechanism could not work.
    # It also means Rails::VERSION is always loaded by the time we look.
    initializer 'patches.version_deprecations', after: :load_config_initializers do
      Patches.warn_about_versions_dropped_in_4_0
    end
  end
end
