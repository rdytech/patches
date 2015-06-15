class Patches::Pending
  include Enumerable

  attr_accessor :path

  def initialize(path=nil)
    @path = path || Patches.default_path
  end

  def each
    return nil unless files

    files.each do |file|
      unless already_run?(file)
        yield file
      end
    end
  end

  private

  def files
    Dir["#{path}/*.rb"].to_a.sort
  end

  def already_run?(path)
    Patches::Patch.path_lookup.has_key?(path)
  end
end
