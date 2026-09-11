# frozen_string_literal: true

class TenantPatchUnsuccessfulError < PatchesError
  attr_reader :tenant, :patch, :exception

  def initialize(message = nil, tenant:, path:, exception:)
    message ||= "Error applying patch '#{path}' for tenant '#{tenant}': #{exception.message}"
    super(message)

    @tenant = tenant
    @path = path
    @exception = exception
  end
end
