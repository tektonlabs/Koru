class RefugeQuestion < ApplicationRecord

  belongs_to :refuge
  belongs_to :entity
  belongs_to :question

end
