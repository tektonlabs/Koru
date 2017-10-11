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

class Admin::Refuges::QuestionnairesController < AdminController

  before_action :set_refuge, only: [:new, :create]

  def new
    @questionnaire = Questionnaire.new
    Question.all.each do |question|
      @questionnaire.responses.build question: question
    end
  end

  def create
    @questionnaire = @refuge.questionnaires.new
    @questionnaire.state_date = Time.now
    if @questionnaire.save_with_responses params[:questions].values
      @questionnaire.refuge.set_status
      redirect_to admin_refuges_path if @questionnaire.save
    else
      question_ids = @questionnaire.responses.map(&:question_id)
      Question.all.each do |question|
        @questionnaire.responses.build question: question if !question_ids.include?(question.id)
      end
      render :new
    end
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:refuge_id]
  end

end
