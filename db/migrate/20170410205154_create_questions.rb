class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.references :entity, foreign_key: true
      t.string :text, null: false
      t.string :min_text
      t.string :max_text
      t.integer :parent_id
      t.integer :question_type, null: false, default: 0

      t.timestamps
    end
  end
end
