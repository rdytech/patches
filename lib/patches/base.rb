class Patches::Base
  # TODO: Use this :/
  def self.tenant(name)
    @tenant = name
  end

  def run
    logger.warn("Run method not implemented for #{self.class.name}")
  end

  def download_file(filename, destination, downloader = nil)
    Patches::FileDownloader.new(
      filename: filename,
      destination: destination,
      downloader: downloader || Patches::Config.configuration.file_downloader,
    ).download
  end

  private

  def execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end

  def logger
    Patches.logger
  end
end
