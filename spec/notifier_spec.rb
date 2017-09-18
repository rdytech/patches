require 'spec_helper'
require 'hipchat'

describe Patches::Notifier do
  let(:notifier) { described_class }

  describe '#send_hipchat_message' do
    subject { notifier.send_hipchat_message(message, options) }

    let(:message) { 'This is a message' }
    let(:options) { { an_option: 'ABC' } }

    before do
      Patches::Config.configuration = nil
      Patches::Config.configure do |config|
        config.use_hipchat = use_hipchat
        config.hipchat_options = {
          api_token: 'HIPCHAT_API_TOKEN',
          room: 'HIPCHAT_ROOM',
          user: 'HIPCHAT_USER',
          api_version: 'v1',
        }
      end
    end

    context 'where Hipchat is defined and use_hipchat config is true' do
      let(:use_hipchat) { true }
      let(:hipchat_client) { HipChat::Client.new('TOKEN') }
      let(:hipchat_client_room) { double('Hipchat Client Room') }

      it 'sends a message to hipchat room' do
        expect(HipChat::Client).to receive(:new).with('HIPCHAT_API_TOKEN', { api_version: 'v1' }).and_return(hipchat_client)
        expect(hipchat_client).to receive(:[]).with('HIPCHAT_ROOM').and_return(hipchat_client_room)
        expect(hipchat_client_room).to receive(:send).
          with('HIPCHAT_USER', 'This is a message', { an_option: 'ABC' })
        subject
      end
    end

    context 'where Hipchat is not defined' do
      let(:use_hipchat) { true }

      before do
        hide_const('HipChat')
      end

      specify do
        expect { subject }.to_not raise_error
      end
    end

    context 'where use_hipchat config is not true' do
      let(:use_hipchat) { false }

      it 'does not send a message to hipchat room' do
        expect(HipChat::Client).to_not receive(:new)
        subject
      end
    end
  end
end
