class CreateEngagements < ActiveRecord::Migration[5.0]
  def change
    create_table :engagements do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :unique_date
      t.references :person_in_charge, foreign_key: true
      t.references :need, foreign_key: true

      t.timestamps
    end
  end
end
