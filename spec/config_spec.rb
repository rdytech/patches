require 'spec_helper'

describe Patches::Config do
  let(:patches_config) { described_class.configuration }

  before do
    described_class.configuration = nil
    described_class.configure do |config|
    end
  end

  describe '#use_sidekiq' do
    subject { patches_config.use_sidekiq }

    context 'when set' do
      before { patches_config.use_sidekiq = true }

      it 'is the configured value' do
        expect(subject).to be_truthy
      end
    end

    context 'when not configured' do
      it 'returns a falsey value' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#sidekiq_queue' do
    subject { patches_config.sidekiq_queue }

    context 'when not configured' do
      it 'is the default queue' do
        expect(subject).to eq('default')
      end
    end

    context 'when configured' do
      before { patches_config.sidekiq_queue = 'patches_queue' }

      it 'is the configured value' do
        expect(subject).to eq('patches_queue')
      end
    end
  end

  describe '#sidekiq_options' do
    subject { patches_config.sidekiq_options }
    before { patches_config.sidekiq_queue = 'default_queue' }

    context 'when not configured' do
      it 'is the default option' do
        expect(subject).to eq({ retry: false, queue: 'default_queue' })
      end
    end

    context 'when configured' do
      before { patches_config.sidekiq_options = { retry: true, queue: 'custom_queue' } }

      it 'is the configured value' do
        expect(subject).to eq({ retry: true, queue: 'custom_queue' })
      end
    end
  end

  describe '#sidekiq_parallel' do
    subject { patches_config.sidekiq_parallel }
    before { patches_config.sidekiq_parallel = true }

    it 'is the configured value' do
      expect(subject).to eq(true)
    end
  end

  describe '#use_slack' do
    subject { patches_config.use_slack }
    before { patches_config.use_slack = true }

    it 'is the configured value' do
      expect(subject).to eq(true)
    end
  end

  describe '#slack_webhook_url' do
    subject { patches_config.slack_webhook_url }
    before { patches_config.slack_options = { webhook_url: 'url' } }

    it 'is webhook_url option from slack_options' do
      expect(subject).to eq('url')
    end
  end

  describe '#slack_channel' do
    subject { patches_config.slack_channel }
    before { patches_config.slack_options = { channel: 'channel-name' } }

    it 'is channel option from slack_options' do
      expect(subject).to eq('channel-name')
    end
  end

  describe '#slack_username' do
    subject { patches_config.slack_username }
    before { patches_config.slack_options = { username: 'slack-bot' } }

    it 'is username option from slack_options' do
      expect(subject).to eq('slack-bot')
    end
  end
end
