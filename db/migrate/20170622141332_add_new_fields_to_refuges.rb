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
