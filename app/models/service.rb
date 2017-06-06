class Service < ApplicationRecord

  validates :name, presence: true

  has_many :refuge_services
  has_many :refuges, through: :refuge_services

end
