class RefugeContact < ApplicationRecord

  belongs_to :refuge
  belongs_to :contact

  enum contact_type: [:secondary, :primary]

end
