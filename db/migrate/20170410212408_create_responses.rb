class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.references :refuge_state, foreign_key: true
      t.references :question_answer, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
