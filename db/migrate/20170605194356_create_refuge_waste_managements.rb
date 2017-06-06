class CreateRefugeWasteManagements < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_waste_managements do |t|
      t.references :refuge, foreign_key: true
      t.references :waste_management, foreign_key: true

      t.timestamps
    end
  end
end
