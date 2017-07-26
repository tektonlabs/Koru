class Engagement < ApplicationRecord

  include FrontRefugesHelper

  validate :dates_consistencies, :not_matching_with_others_engagements

  belongs_to :person_in_charge
  belongs_to :need

  before_create :refactor_dates
  after_create :send_mail_notification

  def send_mail_notification
    AssignNotificationMailer.send_notification(self.person_in_charge.email, date_for_needs_assign(self.start_date, self.end_date, self.unique_date), need.title).deliver_later
  end

  def dates_consistencies
    unless self.start_date.blank?
      unless self.unique_date
        errors.add(:base, "end date must be greater than start date") if self.start_date >= self.end_date
      end
    else
      errors.add(:start_date, "must exists")
    end
  end

  def not_matching_with_others_engagements
    engagements = Engagement.where need_id: self.need_id
    unless self.start_date.blank?
      engagements = self.unique_date ? engagements.where.not("end_date < '#{self.start_date.beginning_of_day}' OR '#{self.start_date.end_of_day}' < start_date") : engagements.where.not("end_date < '#{self.start_date.beginning_of_day}' OR '#{self.end_date.end_of_day}' < start_date")
    end
    errors.add(:base, "must not match with others engagements") unless engagements.empty?
  end

  def refactor_dates
    self.end_date = self.unique_date ? self.start_date.end_of_day : self.end_date.end_of_day
  end

end
