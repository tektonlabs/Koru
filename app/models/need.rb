class Need < ApplicationRecord

  validates :title, presence: true

  belongs_to :questionnaire

end
