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
