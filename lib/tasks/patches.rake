namespace :patches do
  desc "Run Patches"
  task :run => [:environment] do
    if defined?(Apartment) && tenants.present?
      runner = Patches::TenantRunner
    else
      runner = Patches::Runner
    end

    if defined?(Sidekiq) && Patches::Config.configuration.use_sidekiq
      Patches::Worker.perform_async(
        runner,
        application_version: Patches::Config.configuration.application_version
      )
    else
      runner.new.perform
    end
  end

  def tenants
    ENV['DB'] ? ENV['DB'].split(',').map { |s| s.strip } : Apartment.tenant_names || []
  end

  task :pending => [:environment] do
    Patches::Pending.new.each do |patch|
      puts patch
    end
  end
end
