require 'spec_helper'
require 'heatmap/rails/helper'

RSpec.describe Heatmap do
  it "has a version number" do
    expect(Heatmap::Rails::VERSION).not_to be nil
  end
end

RSpec.describe Heatmap::Helper do
  def run_save_heatmap
   Heatmap::Helper.save_heatmap({move: 10, click: 2, html_element: '#test'})
  end
  let(:processed_message) { run_save_heatmap() }
end
