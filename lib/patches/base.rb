class Patches::Base
  def run
    logger.warn("Run method not implemented for #{self.class.name}")
  end

  private
  def execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end

  def logger
    Patches.logger
  end
end
