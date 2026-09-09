require 'spec_helper'

# Sidekiq is an optional integration rather than a runtime dependency: the
# workers in lib/patches.rb are only loaded `if defined?(Sidekiq)`. This spec
# runs in both CI legs and asserts the contract from whichever side applies.
sidekiq_installed = begin
  require 'sidekiq'
  true
rescue LoadError
  false
end

describe 'optional Sidekiq integration' do
  it 'loads the inline runners regardless of Sidekiq' do
    expect(defined?(Patches::Runner)).to eql('constant')
    expect(defined?(Patches::TenantRunner)).to eql('constant')
  end

  if sidekiq_installed
    it 'provides the workers when Sidekiq is installed' do
      require 'patches/worker'
      require 'patches/tenant_worker'
      expect(Patches::Worker.ancestors).to include(Sidekiq::Job)
      expect(Patches::TenantWorker.ancestors).to include(Sidekiq::Job)
    end
  else
    it 'does not define the workers when Sidekiq is absent' do
      expect(defined?(Patches::Worker)).to be_nil
      expect(defined?(Patches::TenantWorker)).to be_nil
    end
  end
end
