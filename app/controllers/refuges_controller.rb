class RefugesController < ApplicationController

  before_action :set_refuge, only: [:show, :detail, :doughnut_graph_settings, :line_graph_settings]

  def index
  end

  def show
    doughnut_graph_settings()
    line_graph_settings()
  end

  def detail
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

  def line_graph_settings
    @line_size = {
      height: 250,
      width: 400
    }

    @line_data = {
      labels: ["January", "February", "March", "April", "May", "June", "July"],
      datasets: [
        {
          label: "My First dataset",
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
          data: [65, 59, 80, 81, 56, 55, 40],
          spanGaps: false,
        }
      ]
    }.to_json
  end

end
