class Patches::TenantRunner
  include Patches::TenantRunConcern
  attr_accessor :path

  def initialize(path: nil, tenants: nil)
    @path = path
    @tenants = tenants
  end

  def perform
    Patches.logger.info("Patches tenant runner for: #{tenants.join(',')}")
    tenants.each do |tenant|
      if parallel?
        Patches::TenantWorker.perform_async(
          tenant,
          path,
          application_version: Patches::Config.configuration.application_version
        )
      else
        run(tenant, path)
      end
    end
  end

  def tenants
    @tenants ||= (Apartment.tenant_names || [])
  end

  def tenants2
    @tenants ||= (Apartment.tenant_names || [])
  end

  def tenants3
    @tenants ||= (Apartment.tenant_names || [])
  end

  private

  def parallel?
    Patches::Config.configuration.sidekiq_parallel
  end
end
