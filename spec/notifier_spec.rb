require 'spec_helper'

describe Patches::Notifier do
  let(:notifier) { described_class }
  let(:message)  { 'This is a message' }

  let(:dummy_tenant_class) do
    Class.new do
      def self.current
        "generic tenant"
      end
    end
  end

  before do
    stub_const("Apartment::Tenant", dummy_tenant_class)
    Patches::Config.configuration = nil
  end

  describe ".notify_success" do
    subject { notifier.notify_success(patches) }

    let(:patches) { %w(one two three) }
    let(:message) { "[DEVELOPMENT] 3 patches succeeded for tenant: generic tenant" }

    before do
      allow(notifier).to receive(:send_slack_message)
    end

    it "sends successful slack message" do
      subject
      expect(notifier).to have_received(:send_slack_message).with(message, "good")
    end
  end

  describe ".notify_failure" do
    subject { notifier.notify_failure(patch_path, error) }

    let(:patch_path) { "/path/to/my_special_patch.rb" }
    let(:error) { "Something crazy" }
    let(:message) { "[DEVELOPMENT] Error applying patch: my_special_patch.rb failed with error: Something crazy for tenant: generic tenant" }

    before do
      allow(notifier).to receive(:send_slack_message)
    end

    it "sends failure slack message" do
      subject
      expect(notifier).to have_received(:send_slack_message).with(message, "danger")
    end
  end

  describe ".success_message" do
    subject { notifier.success_message(patches) }

    let(:patches) { %w(one two three) }
    let(:message) { "[DEVELOPMENT] 3 patches succeeded for tenant: generic tenant" }

    it "generates success message" do
      expect(subject).to eq(message)
    end
  end

  describe ".failure_message" do
    subject { notifier.failure_message(patch_path, error) }

    let(:patch_path) { "/path/to/my_special_patch.rb" }
    let(:error) { "Something crazy" }
    let(:message) { "[DEVELOPMENT] Error applying patch: my_special_patch.rb failed with error: Something crazy for tenant: generic tenant" }

    it "generates failure message" do
      expect(subject).to eq(message)
    end
  end

  describe ".message" do
    subject { notifier.message(arg_1, arg_2, agr_3) }

    let(:arg_1) { "This" }
    let(:arg_2) { "is a" }
    let(:agr_3) { "message" }

    before do
      allow(notifier).to receive(:notification_prefix).and_return(notification_prefix)
      allow(notifier).to receive(:notification_suffix).and_return(notification_suffix)
    end

    context "without notification_prefix" do
      let(:notification_prefix) { nil }
      let(:notification_suffix) { "[SUFFIX]" }

      it "joins all elements except the prefix" do
        expect(subject).to eq("This is a message [SUFFIX]")
      end
    end

    context "without notification_suffix" do
      let(:notification_prefix) { "[PREFIX]" }
      let(:notification_suffix) { nil }

      it "joins all elements except the suffix" do
        expect(subject).to eq("[PREFIX] This is a message")
      end
    end

    context "with notification_prefix and notification_suffix" do
      let(:notification_prefix) { "[PREFIX]" }
      let(:notification_suffix) { "[SUFFIX]" }

      it "joins all elements" do
        expect(subject).to eq("[PREFIX] This is a message [SUFFIX]")
      end
    end
  end

  describe ".notification_prefix" do
    subject { notifier.notification_prefix }

    before do
      Patches::Config.configure do |config|
        config.notification_prefix = notification_prefix
      end
    end

    context "where notification_prefix config specified" do
      let(:notification_prefix) { "Explicit Prefix" }

      it "is that prefix" do
        expect(subject).to eq("[Explicit Prefix]")
      end
    end

    context "where notification_prefix config not specified" do
      let(:notification_prefix) { nil }

      it "defaults to Rails.env" do
        expect(subject).to eq("[DEVELOPMENT]")
      end
    end
  end

  describe ".notification_suffix" do
    subject { notifier.notification_suffix }

    before do
      Patches::Config.configure do |config|
        config.notification_suffix = notification_suffix
      end
    end

    context "where notification_suffix config specified" do
      let(:notification_suffix) { "Explicit suffix" }

      it "is that suffix" do
        expect(subject).to eq("Explicit suffix")
      end
    end

    context "where notification_suffix config not specified" do
      let(:notification_suffix) { nil }

      it "defaults to tenant suffix" do
        expect(subject).to eq("for tenant: generic tenant")
      end
    end
  end

  describe '.send_slack_message' do
    subject { notifier.send_slack_message(message, options) }

    let(:options)  { 'good' }

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
