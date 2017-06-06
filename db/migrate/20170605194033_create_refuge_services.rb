class CreateRefugeServices < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_services do |t|
      t.references :refuge, foreign_key: true
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
