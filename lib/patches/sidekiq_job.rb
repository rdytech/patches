require 'sidekiq'

module Patches
  # Sidekiq renamed Sidekiq::Worker to Sidekiq::Job in 6.3 and still ships the
  # old name as a deprecated alias. Resolving it at include time keeps the
  # workers working on every Sidekiq this gem has ever supported, so the change
  # needs no version bump from consumers.
  def self.sidekiq_job_module
    defined?(::Sidekiq::Job) ? ::Sidekiq::Job : ::Sidekiq::Worker
  end
end
