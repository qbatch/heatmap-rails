require "erb"

module HeatmapRb
  module Helper

    def save_heatmap(options = {})

      click = options.delete(:click) || HeatmapRb.options.delete(:click)
      move = options.delete(:move) || HeatmapRb.options.delete(:move)

      html = ""

      js = <<JS
<script type="text/javascript">
$( document ).ready(function() {
  var move_array = [];
  document.querySelector('.heat_map_body').onmousemove = function(ev) {
    var pageCoords = {x: ev.layerX/$(".heat_map_body").width(), y: ev.layerY/$(".heat_map_body").height()};
    move_array.push(pageCoords);
    if (move_array.length >= parseInt(#{move}))
    {
      var sum = move_array.reduce(function (a, b) {
      return {x: a.x + b.x, y: a.y + b.y};
      });
      var coordinates = { path: window.location.pathname, x: sum['x']/move_array.length, y: sum['y']/move_array.length, type: 'move' };
      move_array=[];
      sendRequest(coordinates);
    }
  };
  var click_array = [];
  document.querySelector('.heat_map_body').onclick = function(ev) {
    var pageCoords = { path: window.location.pathname, x: ev.layerX/$(".heat_map_body").width(), y: ev.layerY/$(".heat_map_body").height(), type: 'click' };
    click_array.push(pageCoords);
    if (click_array.length >= parseInt(#{click}))
    {
      var coordinates = click_array;
      sendRequest({'data': coordinates});
      click_array = [];
    }
  };
  function sendRequest(coordinates_data){
    $.ajax({
       method: "POST",
       url: '/points',
       data: coordinates_data,
       dataType: 'application/json'
    });
  }
});
          </script>
JS

      html += js
      html.respond_to?(:html_safe) ? html.html_safe : html
    end

  end
end
