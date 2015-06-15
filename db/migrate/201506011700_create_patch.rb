class CreatePatch < ActiveRecord::Migration
  def change
    create_table :patches_patch do |t|
      t.string :name, null: false
      t.string :path, null: false
      t.timestamps
    end
  end
end
