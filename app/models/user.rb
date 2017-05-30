class User < ApplicationRecord

  validates :dni, length: { is: 8 }, presence: true

  has_many :questionnaires

  def self.instance_to_save dni
    user = User.find_or_initialize_by dni: dni
    user.save if user.new_record?
    user
  end

end
