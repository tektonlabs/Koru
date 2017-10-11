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

class Api::V1::ResponsesController < Api::ApiV1Controller

  before_action :set_refuge, only: :create

  def create
    questionnaire = @refuge.questionnaires.new
    if questionnaire.save_with_responses params[:questions], params[:current_date], params[:dni]
      questionnaire.refuge.set_status
      render json: { success: true }
    else
      response_error_json_format ErrorResponse.record_not_saved(questionnaire)
    end
  end

  private

  def set_refuge
    @refuge = Refuge.find_by id: params[:refuge_id]
  end

end
