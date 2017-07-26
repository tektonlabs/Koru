class PersonInCharge < ApplicationRecord

  has_many :engagements

  validates :name, :phone, :email, :organization, :responsabilities, presence: true

  accepts_nested_attributes_for :engagements

end
