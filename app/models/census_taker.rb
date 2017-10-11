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

class CensusTaker < ApplicationRecord

  validates :dni, :phone, :institution, presence: true
  validates :dni, length: { is: 8 }
  validates :phone, length: { is: 9 }

  has_many :refuges

  def self.get_or_initialize census_taker_params
    census_taker = CensusTaker.find_or_initialize_by dni: census_taker_params[:dni]
    census_taker.assign_attributes census_taker_params
    census_taker.save
    census_taker
  end

  def self.search search_params
    self.search_by_dni(search_params[:dni]).
      search_by_phone(search_params[:phone])
  end

  def self.search_by_dni dni
    if dni.present?
      where("dni = ?", dni)
    else
      all
    end
  end

  def self.search_by_phone phone
    if phone.present?
      where("phone = ?", phone)
    else
      all
    end
  end

end
