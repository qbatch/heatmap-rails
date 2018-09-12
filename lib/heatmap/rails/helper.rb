require "erb"

module Heatmap
  module Helper

    def exact_route
      "#{params[:controller]}/#{params[:action]}"
    end

    def save_heatmap(options = {})
      click = options[:click] || Heatmap::Rails.options[:click]
      move = options[:move] || Heatmap::Rails.options[:move]
      scroll = options[:scroll] || Heatmap::Rails.options[:scroll]
      html_element = options[:html_element] || Heatmap::Rails.options[:html_element]
      html = ""

      js = <<JS
<script type="text/javascript">
$( document ).ready(function() {
  var move_array = [];
  var scroll_array = [];

  (function() {
    document.onwheel = handleWheelMove;
    function handleWheelMove(event) {
      var dot, eventDoc, doc, body, offsetX, offsetY;
      event = event || window.event;
      if (event.offsetX == null && event.clientX != null) {
        eventDoc = (event.target && event.target.ownerDocument) || document;
        doc = eventDoc.documentElement;
        body = eventDoc.body;
        event.offsetX = event.clientX +
        (doc && doc.scrollLeft || body && body.scrollLeft || 0) -
        (doc && doc.clientLeft || body && body.clientLeft || 0);
        event.offsetY = event.clientY +
        (doc && doc.scrollTop  || body && body.scrollTop  || 0) -
        (doc && doc.clientTop  || body && body.clientTop  || 0 );
      }
      var xpath_element =  xpathstring(event);
      var element_width = event.target.getBoundingClientRect().width;
      var element_height= event.target.getBoundingClientRect().height;
      offset_x_element = event.offsetX / element_width;
      offset_y_element = event.offsetY /  element_height;
      var pageCoords = { path: "#{exact_route}",  type: 'scroll', xpath: xpath_element, offset_x: offset_x_element ,  offset_y: offset_y_element, };

      scroll_array.push(pageCoords);
      if (scroll_array.length >= parseInt(#{scroll})) {
        var coordinates = scroll_array;
        sendRequest({'scroll_data': coordinates, 'total_scrolls': #{scroll} });
        scroll_array = [];
      }
    }
  })();

  document.querySelector('#{html_element}').onmousemove = function(ev) {
    var xpath_element =  xpathstring(ev);
    var element_width = ev.target.getBoundingClientRect().width;
    var element_height= ev.target.getBoundingClientRect().height;
    offset_x_element = ev.offsetX / element_width;
    offset_y_element = ev.offsetY /  element_height;
    var pageCoords = { path: "#{exact_route}",  type: 'move', xpath: xpath_element, offset_x: offset_x_element ,  offset_y: offset_y_element, };

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
    var pageCoords = { path: "#{exact_route}",  type: 'click', xpath: xpath_element, offset_x: offset_x_element ,  offset_y: offset_y_element, };
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
  var e = event.srcElement || event.originalTarget,
  path = xpath(e, '');
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

    def show_heatmap(type = false)
      if type
        heatmap = HeatMap.where(path: exact_route.to_s , click_type: type)
        heatmap_count = HeatMap.where(path: exact_route.to_s , click_type: type).count
        type = type + 's'
      else
        heatmap = HeatMap.where(path: exact_route.to_s)
        heatmap_count = HeatMap.where(path: exact_route.to_s).count
        type = 'heatmaps'
      end
      @data_points = []
      @data_xpaths = []
      @scroll_data = []
      heatmap.each do |coordinate|
        if (coordinate.click_type == "scroll")
          @scroll_data.push({xpath: coordinate.xpath, offset_x: coordinate.offset_x, offset_y:coordinate.offset_y})
        else
          @data_xpaths.push({xpath: coordinate.xpath, offset_x: coordinate.offset_x, offset_y:coordinate.offset_y, value: 100})
        end
      end
      html = ""
      js = <<JS
<script type="text/javascript">
  var heatmapInstance = h337.create({
    container: document.querySelector('body'),
    radius: 40
  });
  window.onload = function() {
    var parent_div = document.createElement("div");
    var text_div = document.createElement("span");
    parent_div.style.padding= "14px";
    parent_div.style.position = "absolute";
    parent_div.style.top = "0";
    parent_div.style.right = "0";
    parent_div.style.background ="rgba(0, 0, 0, 0.7)";
    parent_div.style.color ="white";
    parent_div.style.textAlign ="center";
    var text_node = document.createTextNode("#{type.capitalize} Recorded");
    text_div.appendChild(text_node);
    parent_div.appendChild(text_div);
    var numeric_div = document.createElement("h1");
    var numeric_node =  document.createTextNode("#{heatmap_count}");
    numeric_div.appendChild(numeric_node);
    parent_div.appendChild(numeric_div);
    document.body.appendChild(parent_div);
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
  function getElement(xpath){
     return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
  }
  var xpath_current = JSON.parse('#{raw(@data_xpaths.to_json.html_safe)}');
  var data_xpath = xpath_current.map(function(path){
    if (path != null) {
      element = getElement(path.xpath);
      if (element != null){
        width = element.getBoundingClientRect().width;
        height = element.getBoundingClientRect().height;
        var x_coord = getOffset(path.xpath).x+  (width * path.offset_x);
        var y_coord = getOffset(path.xpath).y+  (height * path.offset_y);
        delete path["xpath_current"];
        delete path["offset_x"];
        delete path["offset_y"];
        path.x = Math.ceil(parseFloat(x_coord));
        path.y = Math.ceil(parseFloat(y_coord));
        return path;
      }
    }
  });
  // Removed: Null Xpath(s)
  var data_xpath = data_xpath.filter(function(val){ return val!==undefined; });

  heatmapInstance.addData(data_xpath);
  var scroll = JSON.parse('#{raw(@scroll_data.to_json.html_safe)}');
  var scroll_data = scroll.map(function(element){
    width = getElement(element.xpath).getBoundingClientRect().width;
    height = getElement(element.xpath).getBoundingClientRect().height;
    dot = document.createElement('div');
    dot.className = "dot";
    dot.style.left = (getOffset(element.xpath).x+  (width * element.offset_x)) + "px";
    dot.style.top = (getOffset(element.xpath).y+  (height * element.offset_y) )+ "px";
    delete element["xpath"];
    delete element["offset_x"];
    delete element["offset_y"];
    dot.style.backgroundColor ="white";
    dot.style.position ="absolute";
    dot.style.borderWidth ="8px";
    dot.style.borderStyle ="solid";
    var colors = Array('#ee3e32', '#f68838' ,'#fbb021', '#1b8a5a','#1d4877');
    var color = colors[Math.floor(Math.random()*colors.length)];
    dot.style.borderColor = color;
    dot.style.borderRadius ="50%";
    dot.style.opacity ="0.7";
    var arrow_node = document.createTextNode("\u21C5");
    dot.appendChild(arrow_node);
    document.body.appendChild(dot);
  });

  scroll_data = scroll_data.filter(function(val){ return val!==undefined; });
</script>
JS

      html += js
      html.respond_to?(:html_safe) ? html.html_safe : html
    end
  end
end
