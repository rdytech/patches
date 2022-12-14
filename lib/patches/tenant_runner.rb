class Patches::TenantRunner
  include Patches::TenantRunConcern
  attr_accessor :path

  def initialize(path: nil)
    @path = path
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
    @tenants ||= Patches::TenantFinder.new.tenant_names
  end

  private

  def parallel?
    Patches::Config.configuration.sidekiq_parallel
  end
end
