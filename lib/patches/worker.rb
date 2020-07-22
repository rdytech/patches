require 'sidekiq'

class Patches::Worker
  include Sidekiq::Worker
  include Patches::ApplicationVersionValidation

  sidekiq_options Patches::Config.configuration.sidekiq_options

  def perform(runner, params = {})
    if valid_application_version?(params['application_version'])
      runner.constantize.new.perform
    else
      self.class.perform_in(Patches::Config.configuration.retry_after_version_mismatch_in, runner, params)
    end
  end
end
