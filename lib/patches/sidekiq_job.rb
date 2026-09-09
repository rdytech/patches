require 'sidekiq'
require 'patches/deprecation'

module Patches
  # Sidekiq renamed Sidekiq::Worker to Sidekiq::Job in 6.3 and still ships the
  # old name as a deprecated alias. Resolving it at include time keeps the
  # workers working on every Sidekiq this gem has ever supported, so the change
  # needs no version bump from consumers.
  def self.sidekiq_job_module
    return ::Sidekiq::Job if defined?(::Sidekiq::Job)

    deprecator.warn(
      'Sidekiq older than 6.3 does not provide Sidekiq::Job; patches 4.0 is ' \
      'expected to require it. Upgrade Sidekiq, which supports 7.x and 8.x.'
    )
    ::Sidekiq::Worker
  end
end
