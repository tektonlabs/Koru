# /* 

# =========================================================================== 
# Koru GPL Source Code 
# Copyright (C) 2017 Tekton Labs
# This file is part of the Koru GPL Source Code.
# Koru Source Code is free software: you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version. 

# Koru Source Code is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
# GNU General Public License for more details. 

# You should have received a copy of the GNU General Public License 
# along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
# =========================================================================== 

# */

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
        errors.add(:base, "end date must be greater than start date") if self.start_date.beginning_of_day >= self.end_date.end_of_day
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
