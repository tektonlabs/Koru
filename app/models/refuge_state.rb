class RefugeState < ApplicationRecord

  validates :state_date, presence: true

  belongs_to :refuge
  has_many :responses

end
