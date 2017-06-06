class HousingStatus < ApplicationRecord

  validates :name, presence: true

  has_many :refuge_housing_statuses
  has_many :refuges, through: :refuge_housing_statuses

end
