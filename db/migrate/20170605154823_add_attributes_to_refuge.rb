# <!--

# =========================================================================== 
# Koru GPL Source Code 
# Copyright (C) 2017 Tekton Labs
# This file is part of the Koru GPL Source Code.
# Koru Source Code is free software: you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version. 

# Koru Source Code is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
# GNU General Public License for more details. 

# You should have received a copy of the GNU General Public License 
# along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
# =========================================================================== 

# */

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
