class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.references :questionnaire, foreign_key: true, null: false
      t.references :question, foreign_key: true, null: false
      t.integer :answer_selected_id, array: true
      t.string :answer_responsed_text

      t.timestamps
    end
  end
end
