class WasteManagement < ApplicationRecord

  validates :name, presence: true

  has_many :refuge_waste_managements
  has_many :refuges, through: :refuge_waste_managements

end
