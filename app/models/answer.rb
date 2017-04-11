class Answer < ApplicationRecord

  validates :name, presence: true

  has_many :question_answers
  has_many :questions, through: :question_answers

end
