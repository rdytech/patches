require 'active_support/core_ext/hash/keys'
require 'patches/sidekiq_job'

class Patches::TenantWorker
  include Patches.sidekiq_job_module
  include Patches::TenantRunConcern
  include Patches::ApplicationVersionValidation

  sidekiq_options Patches::Config.configuration.sidekiq_options

  def perform(tenant_name, path, params = {})
    params = (params || {}).stringify_keys
    if valid_application_version?(params['application_version'])
      run(tenant_name, path)
    else
      self.class.perform_in(Patches::Config.configuration.retry_after_version_mismatch_in, tenant_name, path, params)
    end
  end
end
