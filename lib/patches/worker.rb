require 'sidekiq'

class Patches::Worker
  include Sidekiq::Worker

  sidekiq_options Patches::Config.configuration.sidekiq_options

  def perform(runner)
    runner.constantize.new.perform
  end
end
