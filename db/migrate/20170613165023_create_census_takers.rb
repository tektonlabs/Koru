class CreateCensusTakers < ActiveRecord::Migration[5.0]
  def change
    create_table :census_takers do |t|
      t.string :dni, null: false
      t.string :phone, null: false
      t.string :intitution, null: false

      t.timestamps
    end
  end
end
