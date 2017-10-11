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

class Admin::RefugesController < AdminController

  before_action :set_refuge, only: [:destroy, :new_questionnaire, :create_questionnaire]

  def index
    @refuges = Refuge.search(search_params).includes(:country, :primary_contact, :questionnaires, :census_taker).order(:name).paginate(per_page: 25, page: params[:page])
  end

  def destroy
    @refuge.destroy
    redirect_to admin_root_path
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:id]
  end

  def search_params
    params.permit(:query, :dni)
  end

end
