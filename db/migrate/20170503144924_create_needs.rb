class CreateNeeds < ActiveRecord::Migration[5.0]
  def change
    create_table :needs do |t|
      t.string :title, null: false
      t.text :description
      t.references :questionnaire, foreign_key: true, null: false

      t.timestamps
    end
  end
end
