class CreateRefugeStates < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_states do |t|
      t.references :refuge, foreign_key: true
      t.datetime :state_date

      t.timestamps
    end
  end
end
