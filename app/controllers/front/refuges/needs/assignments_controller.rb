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

class Front::Refuges::Needs::AssignmentsController < FrontController

  before_action :set_refuge, :set_need, only: :new

  def new
    @person_in_charge = PersonInCharge.new
    @person_in_charge.engagements.build
  end

  def create
    @person_in_charge = PersonInCharge.create assignment_params
    redirect_to front_refuge_path params[:refuge_id]
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:refuge_id]
  end

  def set_need
    @need = Need.find params[:need_id]
  end

  def assignment_params
    params.require(:person_in_charge).permit(:name, :phone, :email, :organization, :responsabilities, engagements_attributes:[:start_date, :end_date, :unique_date, :need_id, :person_in_charge_id])
  end

end
