require 'spec_helper'

class DummyPatch < Patches::Base
  def run
    download_file('file.txt', destination)
  end

  private

  def current_path
    File.expand_path(File.dirname(__FILE__))
  end

  def destination
    File.join(current_path, 'file.txt')
  end
end

describe 's3 file download' do
  subject { DummyPatch.new }

  let(:current_path) { File.expand_path(File.dirname(__FILE__)) }
  let(:destination) { File.join(current_path, 'file.txt') }
  let(:s3) { Aws::S3::Client.new(stub_responses: true) }

  before do
    Patches::Config.configure do |config|
      config.file_downloader = {
        type: :s3,
        options: {
          bucket_name: 'my-bucket',
          region: 'region'
        }
      }
    end
    expect(Aws::S3::Client).to receive(:new).and_return(s3)
  end

  after { File.delete(destination) }

  it 'returns the saved file path' do
    expect(subject.run).to include('spec/integrations/file.txt')
  end

  it 'saves the file in the disk' do
    subject.run
    expect(File.exists?(destination)).to be_truthy
  end
end
