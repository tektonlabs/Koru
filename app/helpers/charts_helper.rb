module ChartsHelper

  def doughnut id=nil, size=nil, data=nil, legend=false
    html = "<div class=\"chart-element col-sm-7\"><canvas id=\"pie_#{id}\" height=\"#{size[:height]}\" width=\"#{size[:width]}\" class=\"chart-doughnut\"></canvas></div>"
    html += "<div id=\"legend_#{id}\" class=\"chart-element col-sm-5 chart-doughnut chart-doughnut-legend\"></div>" if legend
    script = javascript_tag do
      <<-END.html_safe
      var ctx_#{id} = document.getElementById("pie_#{id}")
      var legend_box = document.getElementById("legend_#{id}")
      var doughnut_#{id} = new Chart(ctx_#{id}, {
      type: 'doughnut',
        data: #{data},
      options: {
        responsive: true,
        legend: {
          display: 'false',
          position: 'none',
          labels: {
            padding: 30,
          }
        }
      }
      });
      legend_box.innerHTML = doughnut_#{id}.generateLegend();
      END
    end
    return html.html_safe + script
  end

  def line_chart id=nil, size=nil, data=nil
    html = "<canvas id=\"line_#{id}\" class=\"chart-line\" height=\"#{size[:height]}\" width=\"#{size[:width]}\"></canvas>"
    script = javascript_tag do
      <<-END.html_safe
      var ctx_#{id} = document.getElementById("line_#{id}");
      var line_#{id} = new Chart(ctx_#{id}, {
      type: 'line',
        data: #{data},
      options: {
        responsive: true,
        legend: {
          display: 'false',
          position: 'none',
          labels: {
            padding: 30,
          }
        }
      }
      });
      END
    end
    return html.html_safe + script
  end

end
