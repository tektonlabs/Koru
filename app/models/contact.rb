class Contact < ApplicationRecord

  validates :first_name, :last_name, :email, presence: true

  has_many :refuge_contacts
  has_many :refuges, through: :refuge_contacts

  def self.get_or_initialize contact_params
    contact = Contact.find_or_initialize_by email: contact_params[:email]
    contact = Contact.new(contact_params) if contact.new_record?
    contact
  end

end
