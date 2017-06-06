class LightManagement < ApplicationRecord

  validates :name, presence: true

  has_many :refuge_light_managements
  has_many :refuges, through: :refuge_light_managements

end
