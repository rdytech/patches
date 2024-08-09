module Patches
  module TenantRunConcern
    def run(tenant_name, path = nil)
      Apartment::Tenant.switch(tenant_name) do
        Patches::Runner.new(path).perform
      end
    rescue StandardError => e
      Patches.logger.error(e.message)
      Patches.logger.error(e.backtrace.join("\n"))
      raise(TenantPatchUnsuccessfulError, tenant: tenant_name, path: path, exception: e)
    end
  end
end
