class Patches::Patch < ActiveRecord::Base
  validates :name, presence: true
  validates :path, presence: true

  def self.path_lookup
    @names ||= Hash[Patch.pluck(:path, :created_at)]
  end
end
