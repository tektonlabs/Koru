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

class Need < ApplicationRecord

  validates :title, presence: true

  belongs_to :questionnaire
  belongs_to :entity

  has_many :engagements

  def has_current_engagement
    current_engagements = self.engagements.includes(:person_in_charge).where("start_date <= '#{Time.now}' AND end_date >= '#{Time.now}'")
    engagement = current_engagements.blank? ? nil : current_engagements.first
    engagement
  end

  def first_in_engagement_list
    self.engagements.includes(:person_in_charge).where("end_date >= '#{Time.now}'").first
  end

end
