module Patches
  module TenantRunConcern
    def run(tenant_name, path = nil)
      Apartment::Tenant.switch!(tenant_name)
      Patches::Runner.new(path).perform
    end
  end
end
