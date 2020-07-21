module Patches
  module ApplicationVersionValidation
    def valid_application_version?(application_version)
      return true unless application_version
      return true unless Patches::Config.configuration.application_version
      Patches::Config.configuration.application_version == application_version
    end
  end
end
