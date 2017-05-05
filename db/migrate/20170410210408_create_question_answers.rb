class CreateQuestionAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :question_answers do |t|
      t.references :question, foreign_key: true
      t.references :answer, foreign_key: true
      t.integer :class_type, null: false, default: 0
      t.timestamps
    end
  end
end
