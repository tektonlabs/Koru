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
