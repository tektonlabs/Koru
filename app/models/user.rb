class User < ApplicationRecord

  validates :dni, length: { is: 8 }, presence: true

  has_many :questionnaires

end
