class CreateLightManagements < ActiveRecord::Migration[5.0]
  def change
    create_table :light_managements do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
