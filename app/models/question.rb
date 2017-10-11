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

class Question < ApplicationRecord

  validates :text, presence: true

  belongs_to :entity
  belongs_to :parent, class_name: "Question"
  has_many :children, foreign_key: :parent_id, class_name: "Question"
  has_many :question_answers
  has_many :answers, through: :question_answers
  has_many :refuge_questions
  has_many :sub_questions, foreign_key: "parent_id", class_name: "Question"

  enum question_type: [:one_choice, :multiple_choice, :input_value]

end
