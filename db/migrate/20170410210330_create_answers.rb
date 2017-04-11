class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.string :name, null: false
      t.boolean :with_value, null: false, default: false

      t.timestamps
    end
  end
end
