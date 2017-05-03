class Answer < ApplicationRecord

  validates :name, presence: true

  has_many :question_answers
  has_many :questions, through: :question_answers

  def self.text_answers_selected answers_array
    Answer.where(id: answers_array).map(&:name).join(", ")
  end

end
