require 'spec_helper'

describe Patches, '.deprecator' do
  # Collect messages rather than printing them, and restore the behaviour after
  # each example so one spec cannot silence another.
  around do |example|
    original = Patches.deprecator.behavior
    @messages = []
    Patches.deprecator.behavior = ->(message, *) { @messages << message }
    example.run
  ensure
    Patches.deprecator.behavior = original
  end

  it 'is gem-owned rather than the ActiveSupport singleton Rails 8 removed' do
    expect(Patches.deprecator).to be_a(ActiveSupport::Deprecation)
    expect(Patches.deprecator.deprecation_horizon).to eql('5.0')
  end

  it 'can be silenced by a host application' do
    Patches.deprecator.behavior = :silence
    expect { Patches.deprecator.warn('anything') }.not_to raise_error
  end
end
