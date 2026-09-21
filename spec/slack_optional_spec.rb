require 'spec_helper'

# slack-notifier is an optional integration rather than a runtime dependency:
# Patches::Notifier requires it inside a begin/rescue and guards sends with
# `defined?(Slack)`. This spec runs in both CI legs and asserts the contract
# from whichever side applies.
slack_notifier_installed = begin
  require 'slack-notifier'
  true
rescue LoadError
  false
end

describe 'optional Slack integration' do
  before do
    Patches::Config.configure do |config|
      config.use_slack = true
      config.slack_options = { webhook_url: 'https://example.com/hook' }
      # Set so notification_suffix does not fall through to Apartment, which
      # other spec files define without stubbing Apartment::Tenant.current.
      config.notification_suffix = 'spec'
    end
  end

  after { Patches::Config.configuration = nil }

  if slack_notifier_installed
    it 'posts to the webhook when the gem is installed' do
      request = stub_request(:post, 'https://example.com/hook')

      Patches::Notifier.notify_success([])

      expect(request).to have_been_requested
    end
  else
    it 'notifies without raising when the gem is absent' do
      expect(defined?(Slack)).to be_nil
      expect { Patches::Notifier.notify_success([]) }.not_to raise_error
    end
  end
end
