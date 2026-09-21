require 'active_support/deprecation'

module Patches
  # A gem-owned deprecator rather than ActiveSupport::Deprecation's singleton,
  # which Rails 7.1 deprecated and 8.0 removed. Nothing is deprecated in 4.0 -
  # everything 3.7.0 announced has been removed - but this stays: applications
  # were told to configure it to silence those warnings, so removing it would
  # break their initializers. The horizon is the next major.
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('5.0', 'patches')
  end
end
