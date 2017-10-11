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

class Answer < ApplicationRecord

  validates :name, presence: true

  has_many :question_answers
  has_many :questions, through: :question_answers

  def self.text_answers_selected answers_array, other_value
    if answers_array.nil?
      "#{Answer.where(id: answers_array).map(&:name).join(", ")}#{" #{other_value}" unless other_value.blank?}"
    else
      "#{Answer.where(id: answers_array).map(&:name).join(", ")}#{" (#{other_value})" unless other_value.blank?}"
    end
  end

end
