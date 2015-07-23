require 'sidekiq'

class Patches::Worker
  include Sidekiq::Worker

  sidekiq_options Patches::Config.sidekiq_options

  def perform(runner)
    runner.constantize.new.perform
  end
end
