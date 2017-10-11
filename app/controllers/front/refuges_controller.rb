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

class Front::RefugesController < FrontController

  include FrontRefugesHelper

  before_action :set_refuge, only: [:show, :detail, :doughnut_graph_settings, :line_graph_settings, :historical_issues_by_entity, :generate_summary]

  def index
  end

  def show
    doughnut_graph_settings()
    line_graph_settings @refuge.set_last_six_statuses
  end

  def generate_summary
    @rhash = @refuge.data_for_questionaire_pdf
    render pdf: 'summary', layout: 'pdf.html.erb', template: 'front/refuges/summary.pdf.erb'
  end

  def detail
  end

  def historical_issues_by_entity
    params[:entity_id].blank? ? line_graph_settings(@refuge.set_last_six_statuses) : line_graph_settings(@refuge.set_last_six_statuses_by_entity(params[:entity_id]))
  end

  def filter_by
    @refuges = Refuge.filter_by_entity params[:filters], params[:query]
    respond_to do |format|
      format.js
      format.json { render json: @refuges, each_serializer: SearchRefugeSerializer }
    end
  end

  def search_by
    @refuges = Refuge.where id: params[:id]
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:id]
  end

  def doughnut_graph_settings
    @pie_size = {
      height: 250,
      width: 250
    }
    @pie_data = {
      labels: Entity.first_level.order(:created_at).pluck(:name),
      datasets: [
        {
          data: @refuge.refuge_entities.order(:created_at).pluck(:issues_number),
          backgroundColor: [
            "#8E2BFA",
            "#BB26DD",
            "#FD7A8B",
            "#F2A43B",
            "#F7E43B",
            "#5AE1C2",
            "#4DD0E8",
            "#10509E"
          ],
          hoverBackgroundColor: [
            "#8E2BFA",
            "#BB26DD",
            "#FD7A8B",
            "#F2A43B",
            "#F7E43B",
            "#5AE1C2",
            "#4DD0E8",
            "#10509E"
          ]
      }]
    }.to_json
  end

  def line_graph_settings array_values
    @line_size = {
      height: 250,
      width: 400
    }
    @line_data = {
      labels: names_last_six_months,
      datasets: [
        {
          label: "Historical needs",
          fill: false,
          lineTension: 0.1,
          backgroundColor: "#64E67D",
          borderColor: "#64E67D",
          borderCapStyle: 'butt',
          borderDash: [],
          borderDashOffset: 0.0,
          borderJoinStyle: 'miter',
          pointBorderColor: "#64E67D",
          pointBackgroundColor: "#64E67D",
          pointBorderWidth: 5,
          pointHoverRadius: 5,
          pointHoverBackgroundColor: "#fff",
          pointHoverBorderColor: "#64E67D",
          pointHoverBorderWidth: 2,
          pointRadius: 2,
          pointHitRadius: 10,
          data: array_values,
          spanGaps: false,
        }
      ]
    }.to_json
  end

end
