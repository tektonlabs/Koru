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

class SearchRefugeSerializer < ActiveModel::Serializer

  attributes :id, :name, :longitude, :latitude, :city
  attribute :country_name
  attribute :issues_by_entities
  attribute :contact_name
  attribute :contact_phone
  attribute :full_address

  def country_name
    "#{object.country.name}"
  end

  def issues_by_entities
    object.status_by_entity
  end

  def contact_name
    object.primary_contact.nil? ? "" : "#{object.primary_contact.first_name}"
  end

  def contact_phone
    object.primary_contact.nil? ? "" : "#{object.primary_contact.phone}"
  end

  def full_address
    "#{object.city}, #{object.country.name}"
  end

end
