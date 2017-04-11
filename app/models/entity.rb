class Entity < ApplicationRecord

  validates :name, presence: true

  has_many :refuge_entities
  has_many :questions
  has_many :options
  has_many :refuge_questions

  enum level: [:first_level, :second_level, :third_level, :fourth_level]

end
