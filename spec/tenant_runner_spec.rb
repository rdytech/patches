require 'spec_helper'

module Apartment
  module Tenant
  end
end

require 'patches/tenant_runner'

describe Patches::TenantRunner do
  let(:runner) { double('Runner') }

  context 'with tenants' do
    let(:tenants) { ['tenants'] }
    subject { described_class.new(tenants: tenants) }
    specify { expect(subject.tenants).to eql(tenants) }
  end

  context 'perform' do
    before do
      expect(Apartment).to receive(:tenant_names).and_return(['test'])
    end

    specify do
      expect(subject.tenants).to eql(['test'])
      expect(runner).to receive(:perform).and_return(true)
      expect(subject).to receive(:runner).and_return(runner)
      expect(Apartment::Tenant).to receive(:switch).with('test')
      expect(subject.perform).to eql(['test'])
    end
  end
end
