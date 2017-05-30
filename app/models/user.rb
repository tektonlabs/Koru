class User < ApplicationRecord

  validates :dni, length: { is: 8 }, presence: true

  has_many :questionnaires

  def self.instance_to_save dni
    User.find_or_initialize_by dni: dni
  end

end
