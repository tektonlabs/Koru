class FoodManagement < ApplicationRecord

  validates :name, presence: true

  has_many :refuge_food_managements
  has_many :refuges, through: :refuge_food_managements

end
