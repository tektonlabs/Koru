class AddAttributesToRefuge < ActiveRecord::Migration[5.0]
  def change
    add_column :refuges, :refuge_type, :integer
    add_column :refuges, :institution_in_charge, :integer
    add_column :refuges, :emergency_type, :integer
    add_column :refuges, :property_type, :integer
    add_column :refuges, :accessibility, :integer
    add_column :refuges, :victims_provenance, :integer
    add_column :refuges, :floor_type, :integer
    add_column :refuges, :roof_type, :integer
    add_column :refuges, :number_of_families, :integer, null: false, default: 0
    add_column :refuges, :number_of_people, :integer, null: false, default: 0
    add_column :refuges, :number_of_pregnant_women, :integer, null: false, default: 0
    add_column :refuges, :number_of_children_under_3, :integer, null: false, default: 0
    add_column :refuges, :number_of_older_adults, :integer, null: false, default: 0
    add_column :refuges, :number_of_people_with_disabilities, :integer, null: false, default: 0
    add_column :refuges, :number_of_pets, :integer, null: false, default: 0
    add_column :refuges, :number_of_farm_animals, :integer, null: false, default: 0
    add_column :refuges, :number_of_carp, :integer, null: false, default: 0
    add_column :refuges, :number_of_toilets, :integer, null: false, default: 0
    add_column :refuges, :number_of_washbasins, :integer, null: false, default: 0
    add_column :refuges, :number_of_showers, :integer, null: false, default: 0
    add_column :refuges, :number_of_tanks, :integer, null: false, default: 0
    add_column :refuges, :number_of_landfills, :integer, null: false, default: 0
    add_column :refuges, :number_of_garbage_collection_points, :integer, null: false, default: 0
  end
end
