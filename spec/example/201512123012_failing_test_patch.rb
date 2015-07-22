class FailingTestPatch < Patches::Base
  def run
    raise
  end
end