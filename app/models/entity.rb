class Entity < ApplicationRecord

  validates :name, presence: true

  belongs_to :parent, class_name: "Entity", optional: true
  has_many :children, foreign_key: :parent_id, class_name: "Entity"
  has_many :refuge_entities
  has_many :questions
  has_many :options
  has_many :refuge_questions

  enum level: [:first_level, :second_level, :third_level, :fourth_level]

end
