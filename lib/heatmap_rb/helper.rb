module HeatmapRb
  module Helper

    def save_heatmap(options = {})
      puts "*******************************"
      html = "<div></div>"
      html.respond_to?(:html_safe) ? html.html_safe : html
    end

  end
end
