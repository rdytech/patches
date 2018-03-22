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

  before do
    Sidekiq::Testing.fake!
    allow(Patches).to receive(:default_path).and_return('')
  end

  context 'with tenants' do
    let(:tenants) { ['tenants'] }
    subject { described_class.new(tenants: tenants) }
    specify { expect(subject.tenants).to eql(tenants) }
  end

  context 'perform' do
    let(:tenant_names) { ['test'] }

    before { expect(Apartment).to receive(:tenant_names).and_return(tenant_names) }

    specify do
      expect(subject.tenants).to eql(['test'])
      expect(subject).to receive(:run).with('test', nil)
      expect { subject.perform }.not_to change(Patches::TenantWorker.jobs, :size)
    end

    context 'parallel' do
      before { Patches::Config.configuration.sidekiq_parallel = true }

      specify do
        expect(subject.tenants).to eql(['test'])
        expect(Patches::TenantWorker).to receive(:perform_async).with('test', nil).and_call_original
        expect { subject.perform }.to change(Patches::TenantWorker.jobs, :size).by(1)
      end

      context 'for multiple tenants' do
        let(:tenant_names) { ['test', 'test2'] }

        specify do
          expect(subject.tenants).to eql(['test', 'test2'])
          expect(Patches::TenantWorker).to receive(:perform_async).with('test', nil).and_call_original
          expect(Patches::TenantWorker).to receive(:perform_async).with('test2', nil).and_call_original
          expect { subject.perform }.to change(Patches::TenantWorker.jobs, :size).by(2)
        end
      end
    end
  end
end
