class CreateRefuges < ActiveRecord::Migration[5.0]
  def change
    create_table :refuges do |t|
      t.string :name, null: false
      t.string :lat
      t.string :long

      t.timestamps
    end
  end
end
