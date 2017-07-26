class CreatePersonInCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :person_in_charges do |t|
      t.string :name, null: false, default: ''
      t.string :phone, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :organization, null: false, default: ''
      t.text :responsabilities, null: false, default: ''

      t.timestamps
    end
  end
end
