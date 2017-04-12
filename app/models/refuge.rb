class Refuge < ApplicationRecord

  validates :name, presence: true

  has_many :questionnaires
  has_many :refuge_entities
  has_many :entities, through: :refuge_entities
  has_many :refuge_questions
  has_many :questions, through: :refuge_questions

end
