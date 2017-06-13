class User < ApplicationRecord

  validates :dni, length: { is: 8 }, presence: true

  has_many :questionnaires

  def self.search search_params
    self.search_by_dni(search_params[:dni])
  end

  def self.search_by_dni dni
    if dni.present?
      where("dni = ?", dni)
    else
      all
    end
  end

end
