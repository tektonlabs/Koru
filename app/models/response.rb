class Response < ApplicationRecord

  belongs_to :questionnaire
  belongs_to :question

end
