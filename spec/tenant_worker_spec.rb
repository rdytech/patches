require 'spec_helper'
require "patches/tenant_worker"

describe Patches::TenantWorker do
  describe '#perform' do
    specify do
      is_expected.to receive(:run).with('test', 'path')
      subject.perform('test', 'path')
    end
  end
end
