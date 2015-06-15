class Patches::Runner
  attr_accessor :path

  class UnknownPatch < StandardError; end

  def initialize(path=nil)
    @path = path || Patches.default_path
  end

  def perform
    Patches::Pending.new(path).each do |path|
      instance = load_patch(file).new
      instance.run
      Patches::Patch.create(path: path, name: name)
    end
  end

  def existing
    @existing ||= Patches::Patch.pluck(:path)
  end

  private

  def load_patch(path)
    name = class_name(path)
    load_class(name)
  end

  def load_class(name)
    begin
      name.constantize
    rescue
      throw UnknownPatch, "#{file} should define #{name}"
    end
  end

  def class_name(path)
    match = path.match(/\d+_(.+?)\.rb/)
    match.first
  end
end
