class RefugeMailer < ApplicationMailer

  def send_summary refuge
    @refuge = refuge
    mail to: @refuge.primary_contact.email, subject: "Refugios - Resumen diario"
  end

end
