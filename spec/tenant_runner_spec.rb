require 'spec_helper'

module Apartment
  module Tenant
  end
end

require 'patches/tenant_runner'

# Parallel (Sidekiq) behaviour is covered in spec/sidekiq/tenant_runner_spec.rb.
describe Patches::TenantRunner do
  let(:application_version) { 'd8f190c' }

  before do
    Patches::Config.configuration = nil
    allow(Patches).to receive(:default_path).and_return('')
    allow(Patches::Config.configuration).to receive(:application_version) { application_version }
  end

  context 'with tenants' do
    let(:tenants) { ['tenants'] }
    subject { described_class.new(tenants: tenants) }
    specify { expect(subject.tenants).to eql(tenants) }
  end

  context 'perform' do
    let(:tenant_names) { ['test'] }

    before { expect(Apartment).to receive(:tenant_names).and_return(tenant_names) }

    specify 'runs each tenant inline' do
      expect(subject.tenants).to eql(['test'])
      expect(subject).to receive(:run).with('test', nil)
      subject.perform
    end
  end
end
