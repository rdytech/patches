require 'active_support/deprecation'

module Patches
  # A gem-owned deprecator rather than ActiveSupport::Deprecation's singleton,
  # which Rails 7.1 deprecated and 8.0 removed. Host applications can silence or
  # redirect it: Patches.deprecator.behavior = :silence.
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('4.0', 'patches')
  end
end
