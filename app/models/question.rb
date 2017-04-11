class Question < ApplicationRecord

  validates :text, presence: true

  belongs_to :entity
  has_many :question_answers
  has_many :answers, through: :question_answers
  has_many :refuge_questions
  has_many :sub_questions, foreign_key: "parent_id", class_name: "Question"

  enum question_type: [:one_choice, :multiple_choice, :input_value]

end
