class Patches::Pending
  attr_accessor :path

  def initialize(path=nil)
    @path = path || Patches.default_path
  end

  def each
    Dir["#{path}/*.rb"].each do |path|
      yield path unless already_run?(path)
    end
  end

  private
  def already_run?(path)
    Patch.path_lookup.has_key?(path)
  end
end
