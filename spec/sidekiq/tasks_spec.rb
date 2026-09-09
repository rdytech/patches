require 'spec_helper'
require 'rake'
require 'sidekiq/testing'
require 'patches/worker'

# The rake task is where the payload Sidekiq 7+ rejected was built. The worker
# specs pass already-correct arguments, so they stay green even if the task
# regresses; these exercise the task itself. The expectation is on the call
# rather than the recorded job, because Sidekiq JSON-normalises the payload and
# would mask a Class argument whenever strict checking is disabled.
describe 'patches:run' do
  before do
    Rake.application = Rake::Application.new
    Rake::Task.define_task(:environment)
    load File.expand_path('../../lib/tasks/patches.rake', __dir__)

    Sidekiq::Testing.fake!
    Patches::Worker.jobs.clear
    Patches::Config.configuration = nil
    Patches::Config.configuration.use_sidekiq = true
    allow(Patches::Config.configuration).to receive(:application_version).and_return('abc')
  end

  after { Rake.application = Rake::Application.new }

  context 'without Apartment' do
    before { hide_const('Apartment') }

    it 'enqueues the runner by name, with a string-keyed version' do
      expect(Patches::Worker).to receive(:perform_async)
        .with('Patches::Runner', { 'application_version' => 'abc' })
        .and_call_original

      expect { Rake::Task['patches:run'].invoke }
        .to change(Patches::Worker.jobs, :size).by(1)
    end
  end

  context 'with Apartment and tenants' do
    # Defined here rather than relying on another spec file having defined it.
    before do
      apartment = Module.new
      stub_const('Apartment', apartment)
      allow(apartment).to receive(:tenant_names).and_return(['tenant1'])
    end

    it 'enqueues the tenant runner by name' do
      expect(Patches::Worker).to receive(:perform_async)
        .with('Patches::TenantRunner', { 'application_version' => 'abc' })
        .and_call_original

      expect { Rake::Task['patches:run'].invoke }
        .to change(Patches::Worker.jobs, :size).by(1)
    end
  end
end
