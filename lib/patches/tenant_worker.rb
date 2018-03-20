require 'sidekiq'

class Patches::TenantWorker
  include Sidekiq::Worker
  include Patches::TenantRunConcern

  sidekiq_options Patches::Config.configuration.sidekiq_options

  def perform(tenant_name, path)
    run(tenant_name, path)
  end
end
