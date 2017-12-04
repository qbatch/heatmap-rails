require "erb"

module Heatmap
  module Helper

    def save_heatmap(options = {})

      click = options[:click] || Heatmap::Rails.options[:click]
      move = options[:move] || Heatmap::Rails.options[:move]

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
      //sendRequest(coordinates);
    }
  };
  var click_array = [];
  document.querySelector('.heat_map_body').onclick = function(ev) {

    var xpath_element=  xpathstring(ev);
    var pageCoords = { path: window.location.pathname,  type: 'click', xpath: xpath_element };
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
function xpathstring(event) {
    var
    e = event.srcElement || event.originalTarget,
        path = xpath(e, '');;
     return path

}
function xpath(element, suffix) {
    var parent, child_index, node_name;
    parent = element.parentElement;
    if (parent) {
        node_name = element.nodeName.toLowerCase();
        child_index = nodeindex(element, parent.children) + 1;
        return xpath(parent, '/' + node_name + '[' + child_index + ']' + suffix);
    } else {
        return '//html[1]' + suffix;
    }
}
function nodeindex(element, array) {
    var i,
        found = -1,
        element_name = element.nodeName.toLowerCase(),
        matched
       ;

    for (i = 0; i != array.length; ++i) {
        matched = array[i];
        if (matched.nodeName.toLowerCase() === element_name) {
            ++found;


        if (matched === element) {
            return found;
        }
        }
    }

    return -1;
}
function xquery(path) {
    return document.evaluate(
    path,
    document,
    null,
    XPathResult.FIRST_ORDERED_NODE_TYPE,
    null).singleNodeValue;
}

function getOffset( path ) {
    el = document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
    var _x = 0;
    var _y = 0;
    while( el && !isNaN( el.offsetLeft ) && !isNaN( el.offsetTop ) ) {
        _x += el.offsetLeft - el.scrollLeft;
        _y += el.offsetTop - el.scrollTop;
        el = el.offsetParent;
    }
    return { y: _y, x: _x };
}

 </script>
JS

      html += js
      html.respond_to?(:html_safe) ? html.html_safe : html
    end

    def show_heatmap(path)
      heatmap = HeatMap.where(path: path.to_s)
      @data_points = []
      @data_xpaths = []
      heatmap.each do |coordinate|
        @data_xpaths.push({xpath: coordinate.xpath, x: 0, y:0, value: 100})
      end
      html = ""
      js = <<JS
<script type="text/javascript">
  var heatmapInstance = h337.create({
    container: document.querySelector('.heat_map_body'),
    radius: 60
  });
  var xpath = JSON.parse('#{raw(@data_xpaths.to_json.html_safe)}');
  var data_xpath = xpath.map(function(path){
    var x_coord = getOffset(path.xpath).x+25;
    var y_coord = getOffset(path.xpath).y+25;
    delete path["xpath"];
    path.x = parseInt(x_coord);
    path.y = parseInt(y_coord);
    return path;
  });
  heatmapInstance.addData(data_xpath);


</script>
JS
puts js

      html += js
      html.respond_to?(:html_safe) ? html.html_safe : html
    end

  end
end
