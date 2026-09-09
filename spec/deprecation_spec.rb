require 'spec_helper'

describe 'deprecations announced for 4.0' do
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

  it 'owns its deprecator rather than using the removed ActiveSupport singleton' do
    expect(Patches.deprecator).to be_a(ActiveSupport::Deprecation)
    expect(Patches.deprecator.deprecation_horizon).to eql('4.0')
  end

  describe 'Slack notifications' do
    after { Patches::Config.configuration = nil }

    it 'warns when they are enabled that slack-notifier becomes the host\'s' do
      Patches::Config.configuration.use_slack = true
      expect(@messages.join).to include('slack-notifier')
      expect(@messages.join).to include("gem 'slack-notifier'")
    end

    it 'stays quiet when they are not enabled' do
      Patches::Config.configuration.use_slack = false
      expect(@messages).to be_empty
    end
  end

  describe 'Capistrano support' do
    it 'warns that it is removed in 4.0, naming the replacement' do
      Patches.warn_capistrano_support_removed_in_4_0
      expect(@messages.join).to include('patches/capistrano is deprecated')
      expect(@messages.join).to include('rake patches:run')
    end
  end

  describe 'version support' do
    # Both dimensions are stubbed in every example: the suite itself runs on
    # Rubies either side of the announced floor, so leaving one to the ambient
    # version makes these pass or fail by cell.
    it 'warns on a Ruby that CI still verifies but 4.0 will drop' do
      stub_const('RUBY_VERSION', '3.1.4')
      stub_const('Rails::VERSION::STRING', '8.1.0')

      Patches.warn_about_versions_dropped_in_4_0

      expect(@messages.join).to include('Ruby 3.1.4 will not be supported by patches 4.0')
      expect(@messages.join).to include('Ruby >= 3.2')
    end

    it 'warns on a Rails that CI still verifies but 4.0 will drop' do
      stub_const('RUBY_VERSION', '3.4.0')
      stub_const('Rails::VERSION::STRING', '7.1.6')

      Patches.warn_about_versions_dropped_in_4_0

      expect(@messages.join).to include('Rails 7.1.6 will not be supported by patches 4.0')
      expect(@messages.join).to include('Rails >= 7.2')
    end

    it 'stays quiet at the announced floors' do
      stub_const('RUBY_VERSION', '3.2.0')
      stub_const('Rails::VERSION::STRING', '7.2.0')

      Patches.warn_about_versions_dropped_in_4_0

      expect(@messages).to be_empty
    end

    it 'stays quiet above them' do
      stub_const('RUBY_VERSION', '4.0.3')
      stub_const('Rails::VERSION::STRING', '8.1.0')

      Patches.warn_about_versions_dropped_in_4_0

      expect(@messages).to be_empty
    end
  end
end
