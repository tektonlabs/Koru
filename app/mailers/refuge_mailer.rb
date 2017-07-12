class RefugeMailer < ApplicationMailer

  def send_summary refuge
    @refuge = refuge
    @rhash = @refuge.data_for_questionaire_pdf
    pdf_content = render_to_string(pdf: 'summary', template: 'front/refuges/summary.pdf.erb', layout: 'pdf.html.erb')
    pdf = WickedPdf.new.pdf_from_string(pdf_content)
    attachments["#{@refuge.name.gsub(/\s+/, "").underscore}_#{@refuge.last_questionnaire.state_date.strftime("%d_%m_%Y")}.pdf"] = pdf
    mail to: @refuge.primary_contact.email, subject: "Refugios - Resumen diario"
  end

end
