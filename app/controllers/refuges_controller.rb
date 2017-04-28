class RefugesController < ApplicationController

  before_action :set_refuge, only: [:show, :detail]

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
      labels: Entity.first_level.pluck(:name),
      datasets: [
        {
          data: [300, 50, 100, 150, 50, 50, 50, 100],
          backgroundColor: [
            "#EB3349",
            "#64E67D",
            "#FFBB29",
            "#00AEEF",
            "#B96CF5",
            "#BD0FE1",
            "#4990E2",
            "#F8E81C"
          ],
          hoverBackgroundColor: [
            "#EB3349",
            "#64E67D",
            "#FFBB29",
            "#00AEEF",
            "#B96CF5",
            "#BD0FE1",
            "#4990E2",
            "#F8E81C"
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
