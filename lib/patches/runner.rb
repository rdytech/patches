class Patches::Runner
  attr_accessor :path

  class UnknownPatch < StandardError; end

  def initialize(path = nil)
    @path = path || Patches.default_path
  end

  def perform
    completed_patches = pending.each do |file_path|
      klass = load_class(file_path)
      instance = klass.new
      Patches.logger.info("Running #{klass} from #{file_path}")
      begin
        instance.run
      rescue => e
        Patches::Notifier.notify_failure(file_path, format_exception(e))
        raise e
      end
      complete!(patch_path(file_path))
    end
    Patches::Notifier.notify_success(completed_patches)
    completed_patches
  end

  def complete!(patch_path)
    Patches::Patch.create!(path: patch_path)
  end

  def patch_path(patch_path)
    File.basename(patch_path)
  end

  def pending
    @pending ||= Patches::Pending.new(path)
  end

  def format_exception(e)
    "#{e.class.name}: #{e.message} (#{e.backtrace.first})"
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
