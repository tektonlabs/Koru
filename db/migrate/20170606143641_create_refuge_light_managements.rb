class CreateRefugeLightManagements < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_light_managements do |t|
      t.references :refuge, foreign_key: true
      t.references :light_management, foreign_key: true

      t.timestamps
    end
  end
end
