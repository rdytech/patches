require 'spec_helper'
require "patches/tenant_run_concern"

module Apartment
  module Tenant
  end
end

module Patches
  class DummyRun
    include TenantRunConcern
  end
end

describe Patches::TenantRunConcern do
  subject { Patches::DummyRun.new }

  let(:runner) { double(:runner) }

  describe '#run' do
    it 'calls instance perform' do
      expect(Apartment::Tenant).to receive(:switch).with('test')
      expect(Patches::Runner).to receive(:new).with('path').and_return(runner)
      expect(runner).to receive(:perform)
      subject.run('test', 'path')
    end
  end
end
