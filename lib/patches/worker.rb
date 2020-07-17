require 'sidekiq'

class Patches::Worker
  include Sidekiq::Worker

  sidekiq_options Patches::Config.configuration.sidekiq_options

  def perform(runner, params = {})
    runner.constantize.new.perform
  end
end
