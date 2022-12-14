require 'spec_helper'
require 'patches/tenant_finder'

describe Patches::TenantFinder do
  describe '#tenant_names' do
    subject { tenant_finder.tenant_names }
    let(:tenant_finder) { Patches::TenantFinder.new }
    let(:apartment_tenant_names) { ['test1', 'test2', 'test3'] }
    let(:only_tenants_env_var) { nil }
    let(:skip_tenants_env_var) { nil }

    before do
      allow(Apartment).to receive(:tenant_names).and_return(apartment_tenant_names)
      allow(ENV).to receive(:[]).with('ONLY_TENANTS').and_return(only_tenants_env_var)
      allow(ENV).to receive(:[]).with('SKIP_TENANTS').and_return(skip_tenants_env_var)
    end

    context 'when no env vars are set' do
      it 'returns the list from Apartment' do
        expect(subject).to match_array(['test1', 'test2', 'test3'])
      end
    end

    context 'when ONLY_TENANTS is set' do
      let(:only_tenants_env_var) { 'test1,test2' }

      it 'returns a subset of the Apartment list filtered by the env var' do
        expect(subject).to match_array(['test1', 'test2'])
      end
    end

    context 'when SKIP_TENANTS is set' do
      let(:skip_tenants_env_var) { 'test1,test2' }

      it 'returns a subset of the Apartment list excluding names set by the env var' do
        expect(subject).to match_array(['test3'])
      end
    end

    context 'when ONLY_TENANTS and SKIP_TENANTS are set' do
      let(:only_tenants_env_var) { 'test1' }
      let(:skip_tenants_env_var) { 'test1' }

      it 'prioritises the ONLY_TENANTS env var' do
        expect(subject).to match_array(['test1'])
      end
    end
  end
end
