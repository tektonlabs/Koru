class SearchRefugeSerializer < ActiveModel::Serializer

  attributes :id, :name, :longitude, :latitude
  attribute :full_address

  def full_address
    "#{object.city}, #{object.country.name}"
  end

end
