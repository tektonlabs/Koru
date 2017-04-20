class RefugeSerializer < ActiveModel::Serializer

  attributes :id, :name, :longitude, :latitude, :status, :address, :city
  belongs_to :country

end
