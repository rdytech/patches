class Patches::TenantRunner
  attr_accessor :path

  def initialize(path: nil, tenants: nil)
    @path = path
    @tenants = tenants
  end

  def perform
    tenants.each do |tenant|
      Apartment::Tenant.switch(tenant)
      runner.perform
    end
  end

  def runner
    Patches::Runner.new(path)
  end

  def tenants
    @tenants ||= (Apartment.tenant_names || [])
  end
end
