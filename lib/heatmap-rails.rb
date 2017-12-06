require "heatmap/version"
require "heatmap/engine"
require "heatmap/helper"

module Heatmap
  module Rails
    class << self
      attr_accessor :options
    end
    self.options = {click: 3, move: 10, html_element: 'body'}
  end
end
