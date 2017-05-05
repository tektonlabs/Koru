class QuestionAnswer < ApplicationRecord
  
  belongs_to :question
  belongs_to :answer

  enum class_type: [:positive, :negative, :middle]

end
