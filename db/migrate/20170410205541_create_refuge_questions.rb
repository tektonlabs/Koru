class CreateRefugeQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_questions do |t|
      t.references :refuge, foreign_key: true
      t.references :entity, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
