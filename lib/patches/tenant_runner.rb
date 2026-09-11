class Patches::TenantRunner
  include Patches::TenantRunConcern
  attr_accessor :path

  def initialize(path: nil, tenants: nil)
    @path = path
    @tenants = tenants
  end

  def perform
    Patches.logger.info("Patches tenant runner for: #{tenants.join(',')}")
    failures = []
    tenants.each do |tenant|
      if parallel?
        Patches::TenantWorker.perform_async(
          tenant,
          # Sidekiq 7+ rejects anything that is not a native JSON type, and a
          # path is commonly a Pathname (Patches.default_path returns one).
          path && path.to_s,
          'application_version' => Patches::Config.configuration.application_version
        )
      else
        begin
          run(tenant, path)
        rescue TenantPatchUnsuccessfulError => e
          failures << e
        end
      end
    end
    raise_failures(failures) if failures.any?
  end

  def tenants
    @tenants ||= (Apartment.tenant_names || [])
  end

  private

  def parallel?
    Patches::Config.configuration.sidekiq_parallel
  end

  def raise_failures(failures)
    message = 'Patching failed for one or more tenants: '
    message += failures.map { |f| "#{f.tenant} (#{f.path}, #{f.exception.message})" }.join(', ')

    raise(PatchesError, message)
  end
end
