class SuccessfulTestPatch < Patches::Base
  def run
    logger.info("Completed TestPatch")
  end
end
