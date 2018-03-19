module Patches
  class FileDownloader
    def initialize(filename:, downloader:, destination:)
      @filename = filename
      @downloader = downloader
      @destination = destination
    end

    def download
      download_file
    end

    private

    def download_file
      file = @downloader.download(@filename, @destination)
      unless File.exists?(file)
        raise IOError
      else
        file
      end
    end
  end
end
