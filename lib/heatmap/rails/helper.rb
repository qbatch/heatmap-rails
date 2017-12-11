require "erb"

module Heatmap
  module Helper

    def save_heatmap(options = {})

      click = options[:click] || Heatmap::Rails.options[:click]
      move = options[:move] || Heatmap::Rails.options[:move]
      html_element = options[:html_element] || Heatmap::Rails.options[:html_element]
      html = ""

      js = <<JS
<script type="text/javascript">
$( document ).ready(function() {
  var move_array = [];
  document.querySelector('#{html_element}').onmousemove = function(ev) {
    var xpath_element =  xpathstring(ev);
    var element_width = ev.target.getBoundingClientRect().width;
    var element_height= ev.target.getBoundingClientRect().height;
    offset_x_element = ev.offsetX / element_width;
    offset_y_element = ev.offsetY /  element_height;
    var pageCoords = { path: window.location.pathname,  type: 'move', xpath: xpath_element, offset_x: offset_x_element ,  offset_y: offset_y_element, };

    var obj = move_array.find(function (obj) { return obj.xpath === xpath_element; });
    if (obj == null){
     move_array.push(pageCoords);
    }
    if (move_array.length >= parseInt(#{move}))
    {
      var coordinates = move_array;
      sendRequest({'move_data': coordinates,'total_moves': #{move} });
      move_array = [];
    }


  };
  var click_array = [];
  document.querySelector('#{html_element}').onclick = function(ev) {

    var xpath_element=  xpathstring(ev);
    var element_width = ev.target.getBoundingClientRect().width;
    var element_height= ev.target.getBoundingClientRect().height;
    offset_x_element = ev.offsetX / element_width;
    offset_y_element = ev.offsetY /  element_height;
    var pageCoords = { path: window.location.pathname,  type: 'click', xpath: xpath_element, offset_x: offset_x_element ,  offset_y: offset_y_element, };
    click_array.push(pageCoords);
    if (click_array.length >= parseInt(#{click}))
    {
      var coordinates = click_array;
      sendRequest({'click_data': coordinates, 'total_clicks': #{click} });
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
        @data_xpaths.push({xpath: coordinate.xpath, offset_x: coordinate.offset_x, offset_y:coordinate.offset_y, value: 100})
      end
      html = ""
      js = <<JS
<script type="text/javascript">
  var heatmapInstance = h337.create({
    container: document.querySelector('body'),
    radius: 40
  });
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
  function getElement(xpath){
     return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
  }
  var xpath = JSON.parse('#{raw(@data_xpaths.to_json.html_safe)}');
  var data_xpath = xpath.map(function(path){
    width = getElement(path.xpath).getBoundingClientRect().width;
    height = getElement(path.xpath).getBoundingClientRect().height;
    var x_coord = getOffset(path.xpath).x+  (width * path.offset_x);
    var y_coord = getOffset(path.xpath).y+  (height * path.offset_y);
    delete path["xpath"];
    delete path["offset_x"];
    delete path["offset_y"];
    path.x = Math.ceil(parseFloat(x_coord));
    path.y = Math.ceil(parseFloat(y_coord));
    return path;
  });
  heatmapInstance.addData(data_xpath);
</script>
JS

      html += js
      html.respond_to?(:html_safe) ? html.html_safe : html
    end

  end
end
