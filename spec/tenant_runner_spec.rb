require 'spec_helper'
require 'sidekiq/testing'

module Apartment
  module Tenant
  end
end

require 'patches/tenant_runner'
require "patches/tenant_worker"

describe Patches::TenantRunner do
  let(:runner) { double('Runner') }
  let(:application_version) { 'd8f190c' }

  before do
    Patches::Config.configuration = nil
    Sidekiq::Testing.fake!
    allow(Patches).to receive(:default_path).and_return('')
    allow(Patches::Config.configuration).to receive(:application_version) { application_version }
  end

  context 'perform' do
    let(:tenant_names) { ['test'] }
    let(:tenant_finder) { double(Patches::TenantFinder, tenant_names: tenant_names) }

    before { allow(Patches::TenantFinder).to receive(:new).and_return(tenant_finder) }

    specify do
      expect(subject.tenants).to eql(['test'])
      expect(subject).to receive(:run).with('test', nil)
      expect { subject.perform }.not_to change(Patches::TenantWorker.jobs, :size)
    end

    context 'parallel' do
      before { Patches::Config.configuration.sidekiq_parallel = true }

      specify do
        expect(subject.tenants).to eql(['test'])
        expect(Patches::TenantWorker).to receive(:perform_async).with('test', nil, application_version: application_version).and_call_original
        expect { subject.perform }.to change(Patches::TenantWorker.jobs, :size).by(1)
      end

      context 'for multiple tenants' do
        let(:tenant_names) { ['test', 'test2'] }

        specify do
          expect(subject.tenants).to eql(['test', 'test2'])
          expect(Patches::TenantWorker).to receive(:perform_async).with('test', nil, application_version: application_version).and_call_original
          expect(Patches::TenantWorker).to receive(:perform_async).with('test2', nil, application_version: application_version).and_call_original
          expect { subject.perform }.to change(Patches::TenantWorker.jobs, :size).by(2)
        end
      end
    end
  end
end
