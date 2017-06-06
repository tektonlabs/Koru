class CreateRefugeHousingStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_housing_statuses do |t|
      t.references :refuge, foreign_key: true
      t.references :housing_status, foreign_key: true

      t.timestamps
    end
  end
end
