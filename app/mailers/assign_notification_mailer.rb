class AssignNotificationMailer < ApplicationMailer

  def send_notification email, date, need_name
    @date = date
    @need_name = need_name
    mail to: email, subject: "Has asignado una necesidad en Segundos Auxilios!"
  end

end