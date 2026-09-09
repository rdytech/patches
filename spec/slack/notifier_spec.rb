require 'spec_helper'

# Requires slack-notifier, which 4.0 no longer installs - an application that
# sets config.use_slack adds it itself. Kept apart from spec/notifier_spec.rb so
# the suite still runs when the gem is absent.
describe Patches::Notifier do
  let(:notifier) { described_class }
  let(:message) { 'This is a message' }
  let(:options) { 'good' }

  describe '.send_slack_message' do
    subject { notifier.send_slack_message(message, options) }

    before do
      Patches::Config.configure do |config|
        config.use_slack = use_slack
        config.slack_options = {
          webhook_url: 'https://example.com',
          channel: 'deploy-notifications',
          username: 'slack-bot'
        }
      end
    end

    context 'where Slack is defined and use_slack config is true' do
      let(:use_slack) { true }

      it 'sends a message to Slack channel' do
        expect(Slack::Notifier).to receive(:new)
          .with('https://example.com', channel: 'deploy-notifications', username: 'slack-bot')
          .and_call_original

        expect_any_instance_of(Slack::Notifier).to receive(:post)
          .with({ icon_emoji: ":dog:", attachments: [{ text: 'This is a message', color: 'good' }] })

        subject
      end
    end

    context 'use_slack is false' do
      let(:use_slack) { false }

      it "doesn't send a message to Slack channel" do
        expect(Slack::Notifier).not_to receive(:new)
        expect_any_instance_of(Slack::Notifier).not_to receive(:post)
        subject
      end
    end
  end
end
