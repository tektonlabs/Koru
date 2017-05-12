class Need < ApplicationRecord

  validates :title, presence: true

  belongs_to :questionnaire
  belongs_to :entity

end
