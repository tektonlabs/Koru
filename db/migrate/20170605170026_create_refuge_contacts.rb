class CreateRefugeContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_contacts do |t|
      t.references :refuge, foreign_key: true
      t.references :contact, foreign_key: true
      t.integer :contact_type, null: false, default: 0

      t.timestamps
    end
  end
end
