class CreateEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :entities do |t|
      t.string :name, null: false
      t.integer :parent_id
      t.integer :level, null: false, default: 0

      t.timestamps
    end
  end
end
