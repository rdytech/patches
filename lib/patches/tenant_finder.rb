class Patches::TenantFinder

  def tenant_names
    @tenant_names ||= begin
      if only_tenant_names.any?
        apartment_tenant_names.select { |tenant_name| only_tenant_names.include?(tenant_name) }
      elsif skip_tenant_names.any?
        apartment_tenant_names.reject { |tenant_name| skip_tenant_names.include?(tenant_name) }
      else
        apartment_tenant_names
      end
    end
  end

  private

  def apartment_tenant_names
    Apartment.tenant_names || []
  end

  def only_tenant_names
    ENV['ONLY_TENANTS'] ? ENV['ONLY_TENANTS'].split(',').map { |s| s.strip } : []
  end

  def skip_tenant_names
    ENV['SKIP_TENANTS'] ? ENV['SKIP_TENANTS'].split(',').map { |s| s.strip } : []
  end
end
