class Need < ApplicationRecord

  validates :title, presence: true

  belongs_to :questionnaire
  belongs_to :entity

  has_many :engagements

  def has_current_engagement
    current_engagements = self.engagements.includes(:person_in_charge).where("start_date <= '#{Time.now}' AND end_date >= '#{Time.now}'")
    engagement = current_engagements.blank? ? nil : current_engagements.first
    engagement
  end

  def first_in_engagement_list
    self.engagements.includes(:person_in_charge).where("end_date >= '#{Time.now}'").first
  end

end
