class AddNewFieldsToRefuges < ActiveRecord::Migration[5.0]
  def change
    add_column :refuges, :number_of_children_under_3_male, :integer, null: false, default: 0
    add_column :refuges, :number_of_children_under_3_female, :integer, null: false, default: 0
    add_column :refuges, :number_of_people_less_than_or_equals_to_18_male, :integer, null: false, default: 0
    add_column :refuges, :number_of_people_less_than_or_equals_to_18_female, :integer, null: false, default: 0
    add_column :refuges, :number_of_people_older_than_18_male, :integer, null: false, default: 0
    add_column :refuges, :number_of_people_older_than_18_female, :integer, null: false, default: 0
    add_column :refuges, :number_of_older_adults_male, :integer, null: false, default: 0
    add_column :refuges, :number_of_older_adults_female, :integer, null: false, default: 0
    remove_column :refuges, :number_of_people, :integer
    remove_column :refuges, :number_of_children_under_3, :integer
    remove_column :refuges, :number_of_older_adults, :integer
  end
end
