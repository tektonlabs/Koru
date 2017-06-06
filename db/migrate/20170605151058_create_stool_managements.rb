class CreateStoolManagements < ActiveRecord::Migration[5.0]
  def change
    create_table :stool_managements do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
