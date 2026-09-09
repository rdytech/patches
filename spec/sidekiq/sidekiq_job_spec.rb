require 'spec_helper'
require 'patches/sidekiq_job'

describe 'Patches.sidekiq_job_module' do
  it 'prefers Sidekiq::Job, the name Sidekiq has used since 6.3' do
    expect(Patches.sidekiq_job_module).to eql(Sidekiq::Job)
  end

  it 'falls back to Sidekiq::Worker when Sidekiq::Job is unavailable' do
    hide_const('Sidekiq::Job')
    expect(Patches.sidekiq_job_module).to eql(Sidekiq::Worker)
  end
end
