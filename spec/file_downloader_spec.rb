require 'spec_helper'

describe Patches::FileDownloader do
  subject { described_class.new(filename: 'filename', destination: 'destination', downloader: downloader) }

  let(:downloader) { double(:downloader) }

  context 'for a successfully downloaded file' do
    let(:tempfile) { Tempfile.new }

    it 'returns the file path' do
      expect(downloader).to receive(:download).with('filename', 'destination').and_return(tempfile.path)
      expect(subject.download).to eq tempfile.path
    end
  end

  context 'when file has not been saved' do
    it 'raises IOError' do
      expect(downloader).to receive(:download).with('filename', 'destination').and_return('anything')
      expect { subject.download }.to raise_error(IOError)
    end
  end
end
