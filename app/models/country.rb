class Country < ApplicationRecord

  validates :name, :iso, presence: true

  has_many :refuges

end
