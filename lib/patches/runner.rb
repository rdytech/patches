class Patches::Runner
  attr_accessor :path

  class UnknownPatch < StandardError; end

  def initialize(path = nil)
    @path = path || Patches.default_path
  end

  def perform
    pending.each do |file_path|
      klass = load_class(file_path)
      instance = klass.new
      Patches.logger.info("Running #{klass} from #{file_path}")
      instance.run
      complete!(patch_path(file_path))
    end
  end

  def complete!(patch_path)
    Patches::Patch.create!(path: patch_path)
  end

  def patch_path(patch_path)
    File.basename(patch_path)
    # Pathname.new(patch_path).relative_path_from(path).to_s
  end

  def pending
    @pending ||= Patches::Pending.new(path)
  end

  private
  def load_class(path)
    begin
      name = Patches.class_name(path)
      load path
      name.constantize
    rescue StandardError, LoadError
      raise UnknownPatch, "#{path} should define #{name}"
    end
  end
end
