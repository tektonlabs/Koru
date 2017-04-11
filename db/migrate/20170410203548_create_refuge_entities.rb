class CreateRefugeEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_entities do |t|
      t.references :entity, foreign_key: true
      t.references :refuge, foreign_key: true

      t.timestamps
    end
  end
end
