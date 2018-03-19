require 'aws-sdk-s3'

module Patches
  module FileDownloaders
    class S3Downloader
      def initialize(bucket_name:, region:)
        @bucket_name = bucket_name
        @region = region
      end

      def download(filename, destination)
        get_remote_file(filename, destination)
        destination
      end

      private

      def get_remote_file(filename, destination)
        aws_client.get_object(bucket: @bucket_name, key: filename, response_target: destination)
      end

      def aws_client
        Aws::S3::Client.new(region: @region)
      end
    end
  end
end
