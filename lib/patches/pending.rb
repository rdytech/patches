class Patches::Pending
  include Enumerable

  attr_accessor :path

  def initialize(path=nil)
    @path = path || Patches.default_path
  end

  def each
    return nil unless files
    new_files = files.reject { |file| already_run?(file) }
    Patches.logger.info("Patches found: #{new_files.join(',')}")

    new_files.each do |file|
      unless already_run?(file)
        yield file
      end
    end
  end

  private

  def files
    @files ||= Dir[File.join(path, "*.rb")].to_a.sort
  end

  def already_run?(path)
    patches[File.basename(path)]
  end

  def patches
    @patches ||= Patches::Patch.path_lookup
  end
end
