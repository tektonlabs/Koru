class CreateQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    create_table :questionnaires do |t|
      t.references :refuge, foreign_key: true
      t.datetime :state_date

      t.timestamps
    end
  end
end
