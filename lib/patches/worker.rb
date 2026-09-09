require 'active_support/core_ext/hash/keys'
require 'patches/sidekiq_job'

class Patches::Worker
  include Patches.sidekiq_job_module
  include Patches::ApplicationVersionValidation

  sidekiq_options Patches::Config.configuration.sidekiq_options

  def perform(runner, params = {})
    params = (params || {}).stringify_keys
    if valid_application_version?(params['application_version'])
      runner.constantize.new.perform
    else
      self.class.perform_in(Patches::Config.configuration.retry_after_version_mismatch_in, runner, params)
    end
  end
end
