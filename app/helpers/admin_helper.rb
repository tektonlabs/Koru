# /* 

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

module AdminHelper

  def set_census_taker census_taker
    census_taker.nil? ? "No se ha registrado" : census_taker.dni
  end

  def set_city_country refuge
    refuge.city.blank? ? "#{refuge.country.name}" : "#{refuge.city}, #{refuge.country.name}"
  end

  def only_date date
    date.blank? ? "-" : date.strftime("%d/%m/%Y")
  end

  def only_hours hour
    hour.blank? ? "-" : hour.strftime("%H:%M")
  end

  def refuges_all
    @refuges ||= Refuge.all
  end

  def set_contact primary_contact
    primary_contact.nil? ? "No se ha registrado" : "#{primary_contact.first_name}"
  end

  def set_user_questionnaire user
    user.nil? ? 'No se ha registrado' : user.dni
  end

  def entities_all
    @first_level_entities ||= Entity.first_level
  end

  def set_entity entity
    entity = entity.parent.nil? ? entity : entity.parent
  end

end
