module Patches
  module FileDownloaderConfigConcern
    FILE_DOWNLOADERS = [:s3]

    def file_downloader=(value)
      @file_downloader = value.is_a?(Proc) ? value : initialize_file_downloader(value)
    end

    private

    def valid_downloader?(downloader)
      FILE_DOWNLOADERS.include?(downloader)
    end

    def initialize_file_downloader(downloader)
      raise ArgumentError unless valid_downloader?(downloader[:type])
      case downloader[:type]
      when :s3
        initialize_s3_downloader(downloader[:options])
      end
    end

    def initialize_s3_downloader(options)
      raise ArgumentError, 'Downloader not configured' if options.blank?
      Patches::FileDownloaders::S3Downloader.new(
        bucket_name: options[:bucket_name],
        region: options[:region]
      )
    end
  end
end
