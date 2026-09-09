require 'patches/sidekiq_job'

class Patches::TenantWorker
  include Patches.sidekiq_job_module
  include Patches::TenantRunConcern
  include Patches::ApplicationVersionValidation

  sidekiq_options Patches::Config.configuration.sidekiq_options

  def perform(tenant_name, path, params = {})
    params = (params || {}).transform_keys(&:to_s)
    if valid_application_version?(params['application_version'])
      run(tenant_name, path)
    else
      self.class.perform_in(Patches::Config.configuration.retry_after_version_mismatch_in, tenant_name, path, params)
    end
  end
end
