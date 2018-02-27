require "heatmap/rails/version"
require "heatmap/rails/engine"
require "heatmap/rails/helper"

module Heatmap
  module Rails
    class << self
      attr_accessor :options
    end
    self.options = {click: 3, move: 10, html_element: 'body', scroll: 10}
  end
end
