class Patches::Base
  def run

  end

  private
  def execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end
end
