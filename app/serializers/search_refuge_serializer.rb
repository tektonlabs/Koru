class SearchRefugeSerializer < ActiveModel::Serializer

  attributes :id, :name, :longitude, :latitude, :city
  attribute :country_name
  attribute :issues_by_entities
  attribute :contact_name
  attribute :contact_phone
  attribute :full_address

  def country_name
    "#{object.country.name}"
  end

  def issues_by_entities
    object.status_by_entity
  end

  def contact_name
    object.primary_contact.nil? ? "" : "#{object.primary_contact.first_name}"
  end

  def contact_phone
    object.primary_contact.nil? ? "" : "#{object.primary_contact.phone}"
  end

  def full_address
    "#{object.city}, #{object.country.name}"
  end

end
