require 'spec_helper'

describe Patches::FileDownloaders::S3Downloader do
  subject { described_class.new(bucket_name: 'bucket', region: 'ap-southeast-2') }

  let(:current_path) { File.expand_path(File.dirname(__FILE__)) }
  let(:destination) { File.join(current_path, 'a.png') }
  let(:download) { subject.download('a.png', destination) }

  context 'stubbed' do
    let(:s3) { Aws::S3::Client.new(stub_responses: true) }

    before { expect(Aws::S3::Client).to receive(:new).and_return(s3) }

    context 'for a successfully downloaded file' do
      after { File.delete(destination) }

      it 'saves the file' do
        download
        expect(File.exists?(destination)).to be_truthy
      end

      it 'returns the file path' do
        expect(download).to eq destination
      end
    end

    context 'when there is an error downloading the file' do
      before { s3.stub_responses(:get_object, 'NotFound') }

      it 'raises an error' do
        expect { download }.to raise_error(Aws::S3::Errors::NotFound)
        expect(File.exists?(destination)).to be_falsey
      end
    end

    context 'with invalid credentials' do
      before { s3.stub_responses(:get_object, 'InvalidAccessKeyId') }

      it 'raises an error' do
        expect { download }.to raise_error(Aws::S3::Errors::InvalidAccessKeyId)
        expect(File.exists?(destination)).to be_falsey
      end
    end
  end
end
