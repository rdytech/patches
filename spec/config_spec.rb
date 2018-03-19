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
    before { patches_config.use_sidekiq = true }

    it 'is the configured value' do
      expect(subject).to eq(true)
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

  describe '#use_hipchat' do
    subject { patches_config.use_hipchat }
    before { patches_config.use_hipchat = true }

    it 'is the configured value' do
      expect(subject).to eq(true)
    end
  end

  describe '#hipchat_api_token' do
    subject { patches_config.hipchat_api_token }
    before { patches_config.hipchat_options = { api_token: 'hipchat_api_token' } }

    it 'is api_token option from hipchat_options' do
      expect(subject).to eq('hipchat_api_token')
    end
  end

  describe '#hipchat_init_options' do
    subject { patches_config.hipchat_init_options }

    context 'when extra options exist' do
      before do
        patches_config.hipchat_options = {
          api_token: 'hipchat_api_token',
          room: 'hipchat_room',
          user: 'hipchat_user',
          api_version: 'v1',
        }
      end

      it 'is all options from hipchat_options except :api_token, :room and :user' do
        expect(subject).to eq({ api_version: 'v1' })
      end
    end

    context 'when no extra options exist' do
      before do
        patches_config.hipchat_options = {
          api_token: 'hipchat_api_token',
          room: 'hipchat_room',
          user: 'hipchat_user',
        }
      end

      it 'is an empty hash' do
        expect(subject).to eq({ })
      end
    end
  end

  describe '#hipchat_room' do
    subject { patches_config.hipchat_room }
    before { patches_config.hipchat_options = { room: 'hipchat_room' } }

    it 'is room option from hipchat_options' do
      expect(subject).to eq('hipchat_room')
    end
  end

  describe '#hipchat_user' do
    subject { patches_config.hipchat_user }
    before { patches_config.hipchat_options = { user: 'hipchat_user' } }

    it 'is user option from hipchat_options' do
      expect(subject).to eq('hipchat_user')
    end
  end

  describe '#file_downloader' do
    context 'supported' do
      context 'S3' do
        context 'with options' do
          let(:options) do
            {
              bucket_name: 'bucket',
              region: 'region'
            }
          end

          before do
            expect(Patches::FileDownloaders::S3Downloader).to receive(:new).with(
              bucket_name: 'bucket',
              region: 'region'
            ).and_call_original
            patches_config.file_downloader = { type: :s3, options: options }
          end

          it 'initializes S3 Downloader' do
            expect(patches_config.file_downloader).to be_a Patches::FileDownloaders::S3Downloader
          end
        end

        context 'without options' do
          let(:options) { nil }

          it 'raises ArgumentError' do
            expect { patches_config.file_downloader = { type: :s3, options: options } }.to raise_error(ArgumentError)
          end
        end
      end
    end

    context 'not supported' do
      it 'raises an error' do
        expect { patches_config.file_downloader = { type: :google } }.to raise_error(ArgumentError)
      end
    end

    context 'type not present' do
      it 'raises an error' do
        expect { patches_config.file_downloader = {} }.to raise_error(ArgumentError)
      end
    end

    context 'custom downloader' do
      let(:downloader) { double(:downloader) }

      before { patches_config.file_downloader = -> { downloader } }

      it 'sets the downloader' do
        expect(patches_config.file_downloader).to be_a Proc
      end
    end
  end
end
