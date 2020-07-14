require 'sidekiq'

class Patches::Worker
  include Sidekiq::Worker

  sidekiq_options Patches::Config.configuration.sidekiq_options

  def perform(runner, params = {})
    if valid_application_version?(params)
      runner.constantize.new.perform
    else
      self.class.perform_in(Patches::Config.configuration.retry_after_version_mismatch_in, runner, params)
    end
  end

  private

  def valid_application_version?(params)
    return true unless params[:application_version]
    return true unless Patches::Config.configuration.application_version
    Patches::Config.configuration.application_version == params[:application_version]
  end
end
