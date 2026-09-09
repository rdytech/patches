class CreatePatch < ActiveRecord::Migration[5.0]
  def change
    create_table :patches_patches do |t|
      t.string :path, null: false
      t.timestamps
    end

    add_index :patches_patches, :path, unique: true
  end
end
