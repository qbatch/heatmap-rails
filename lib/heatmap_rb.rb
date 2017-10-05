require "heatmap_rb/version"
require "heatmap_rb/engine"
require "heatmap_rb/helper"

module HeatmapRb
  class << self
    attr_accessor :options
  end
  self.options = {click: 3, move: 50}
end
