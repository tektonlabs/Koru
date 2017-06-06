class CreateRefugeStoolManagements < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_stool_managements do |t|
      t.references :refuge, foreign_key: true
      t.references :stool_management, foreign_key: true

      t.timestamps
    end
  end
end
