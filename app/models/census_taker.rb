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

  def self.search search_params
    self.search_by_dni(search_params[:dni]).
      search_by_phone(search_params[:phone])
  end

  def self.search_by_dni dni
    if dni.present?
      where("dni = ?", dni)
    else
      all
    end
  end

  def self.search_by_phone phone
    if phone.present?
      where("phone = ?", phone)
    else
      all
    end
  end

end
