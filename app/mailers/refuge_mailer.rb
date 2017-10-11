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
