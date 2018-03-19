require 'spec_helper'

describe Patches::Base do
  describe '#download' do
    let(:downloader) { double(:downloader) }

    let(:file) { Tempfile.new }

    after { file.unlink }

    context 'with downloader set' do
      before { allow(Patches::Config.configuration).to receive(:file_downloader).and_return(downloader) }

      it 'returns the downloaded filepath' do
        expect(downloader).to receive(:download).with('filename', 'destination').and_return(file.path)
        expect(Patches::FileDownloader).to receive(:new).with(
          filename: 'filename',
          destination: 'destination',
          downloader: downloader
        ).and_call_original
        expect(subject.download_file('filename', 'destination')).to eq file.path
      end
    end

    context 'with a custom downloader' do
      it 'returns the downloaded filepath' do
        expect(downloader).to receive(:download).with('filename', 'destination').and_return(file.path)
        expect(Patches::FileDownloader).to receive(:new).with(
          filename: 'filename',
          destination: 'destination',
          downloader: downloader
        ).and_call_original
        expect(subject.download_file('filename', 'destination', downloader)).to eq file.path
      end
    end
  end
end
