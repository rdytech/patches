module Patches
  class Railtie < Rails::Railtie
    rake_tasks do
      load "lib/tasks/patches.rake"
    end
  end
end
