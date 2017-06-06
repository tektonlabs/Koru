class StoolManagement < ApplicationRecord

  validates :name, presence: true

  has_many :refuge_stool_managements
  has_many :refuges, through: :refuge_stool_managements

end
