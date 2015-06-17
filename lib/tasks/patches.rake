require 'patches/tenant_runner'

namespace :patches do
  desc "Run Patches"
  task :run => [:environment] do
    if defined?(Apartment)
      Patches::TenantRunner.new(tenants: tenants).perform
    else
      Patches::Runner.new.perform
    end
  end

  def tenants
    ENV['DB'] ? ENV['DB'].split(',').map { |s| s.strip } : Apartment.tenant_names || []
  end

  task :pending => [:environment] do
    Patches::Pending.each do |patch|
      puts patch
    end
  end
end
