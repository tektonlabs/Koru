class CreateRefugeAreas < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_areas do |t|
      t.references :refuge, foreign_key: true
      t.references :area, foreign_key: true

      t.timestamps
    end
  end
end
