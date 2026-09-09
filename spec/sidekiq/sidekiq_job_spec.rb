require 'spec_helper'
require 'patches/sidekiq_job'

describe 'Patches.sidekiq_job_module' do
  it 'prefers Sidekiq::Job, the name Sidekiq has used since 6.3' do
    expect(Patches.sidekiq_job_module).to eql(Sidekiq::Job)
  end

  it 'falls back to Sidekiq::Worker when Sidekiq::Job is unavailable' do
    hide_const('Sidekiq::Job')
    allow(Patches.deprecator).to receive(:warn)
    expect(Patches.sidekiq_job_module).to eql(Sidekiq::Worker)
  end

  it 'announces that 4.0 is expected to require Sidekiq::Job' do
    hide_const('Sidekiq::Job')
    messages = []
    original = Patches.deprecator.behavior
    Patches.deprecator.behavior = ->(message, *) { messages << message }

    Patches.sidekiq_job_module

    expect(messages.join).to include('Sidekiq older than 6.3')
  ensure
    Patches.deprecator.behavior = original
  end

  it 'stays quiet on a Sidekiq that provides Sidekiq::Job' do
    expect(Patches.deprecator).not_to receive(:warn)
    Patches.sidekiq_job_module
  end
end
