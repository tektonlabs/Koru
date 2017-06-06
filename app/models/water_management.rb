class WaterManagement < ApplicationRecord

  validates :name, presence: true

  has_many :refuge_water_managements
  has_many :refuges, through: :refuge_water_managements

end
