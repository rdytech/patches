require 'spec_helper'

describe Patches::Notifier do
  let(:notifier) { described_class }
  let(:message)  { 'This is a message' }

  describe '#send_slack_message' do
    let(:options)  { 'good' }
    subject { notifier.send_slack_message(message, options) }

    before do
      Patches::Config.configuration = nil
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

    context 'where Slack is not defined' do
      let(:use_slack) { true }

      before do
        hide_const('Slack')
      end

      specify do
        expect { subject }.to_not raise_error
      end
    end
  end
end
