class CensusTaker < ApplicationRecord

  validates :dni, :phone, :institution, presence: true
  validates :dni, length: { is: 8 }
  validates :phone, length: { is: 9 }

  has_many :refuges

  def self.get_or_initialize census_taker_params
    census_taker = CensusTaker.find_or_initialize_by dni: census_taker_params[:dni]
    census_taker.assign_attributes census_taker_params
    census_taker.save
    census_taker
  end

end
