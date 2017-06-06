class CreateParentTable < ActiveRecord::Migration[5.0]

  def up
    execute "CREATE TABLE refuge_resources (id INTEGER, name VARCHAR);"
    execute "ALTER TABLE areas INHERIT refuge_resources; ALTER TABLE committees INHERIT refuge_resources; ALTER TABLE services INHERIT refuge_resources; ALTER TABLE housing_statuses INHERIT refuge_resources; ALTER TABLE food_managements INHERIT refuge_resources; ALTER TABLE light_managements INHERIT refuge_resources; ALTER TABLE stool_managements INHERIT refuge_resources; ALTER TABLE waste_managements INHERIT refuge_resources; ALTER TABLE water_managements INHERIT refuge_resources;"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
