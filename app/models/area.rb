class Area < ApplicationRecord

  validates :name, presence: true

  has_many :refuge_areas
  has_many :refuges, through: :refuge_areas

end
