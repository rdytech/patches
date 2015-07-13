class Patches::TenantRunner
  attr_accessor :path

  def initialize(path: nil, tenants: nil)
    @path = path
    @tenants = tenants
  end

  def perform
    Patches.logger.info("Patches tenant runner for: #{tenants.join(',')}")

    tenants.each do |tenant|
      Apartment::Tenant.switch(tenant)
      runner = build
      runner.perform
    end
  end

  def build
    Patches::Runner.new(path)
  end

  def tenants
    @tenants ||= (Apartment.tenant_names || [])
  end
end
