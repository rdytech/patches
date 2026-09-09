require 'rails/engine'

module Patches
  class Engine < Rails::Engine
    isolate_namespace Patches
  end
end
