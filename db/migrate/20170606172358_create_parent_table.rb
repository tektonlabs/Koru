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

class CreateParentTable < ActiveRecord::Migration[5.0]

  def up
    execute "CREATE TABLE refuge_resources (id INTEGER, name VARCHAR);"
    execute "ALTER TABLE areas INHERIT refuge_resources; ALTER TABLE committees INHERIT refuge_resources; ALTER TABLE services INHERIT refuge_resources; ALTER TABLE housing_statuses INHERIT refuge_resources; ALTER TABLE food_managements INHERIT refuge_resources; ALTER TABLE light_managements INHERIT refuge_resources; ALTER TABLE stool_managements INHERIT refuge_resources; ALTER TABLE waste_managements INHERIT refuge_resources; ALTER TABLE water_managements INHERIT refuge_resources;"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
