require 'active_support/deprecation'

module Patches
  # A gem-owned deprecator rather than ActiveSupport::Deprecation's singleton,
  # which Rails 7.1 deprecated and 8.0 removed. Host applications can silence or
  # redirect it: Patches.deprecator.behavior = :silence.
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('4.0', 'patches')
  end

  # The floors 4.0 is expected to set. Deliberately higher than what CI verifies
  # today - Ruby 3.0 and Rails 7.1 still pass - so consumers on those versions
  # hear about it a release ahead rather than at upgrade time.
  MINIMUM_RUBY_IN_4_0 = '3.2'.freeze
  MINIMUM_RAILS_IN_4_0 = '7.2'.freeze

  def self.warn_capistrano_support_removed_in_4_0
    deprecator.warn(
      'patches/capistrano is deprecated and will be removed in 4.0. Invoke ' \
      '`rake patches:run` from your deployment process instead.'
    )
  end

  def self.warn_about_versions_dropped_in_4_0
    if Gem::Version.new(RUBY_VERSION) < Gem::Version.new(MINIMUM_RUBY_IN_4_0)
      deprecator.warn(
        "Ruby #{RUBY_VERSION} will not be supported by patches 4.0, which is " \
        "expected to require Ruby >= #{MINIMUM_RUBY_IN_4_0}."
      )
    end

    return unless defined?(::Rails::VERSION::STRING)
    return if Gem::Version.new(::Rails::VERSION::STRING) >= Gem::Version.new(MINIMUM_RAILS_IN_4_0)

    deprecator.warn(
      "Rails #{::Rails::VERSION::STRING} will not be supported by patches 4.0, " \
      "which is expected to require Rails >= #{MINIMUM_RAILS_IN_4_0}."
    )
  end
end
