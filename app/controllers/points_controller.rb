class PointsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    puts "HI"
    if params[:data].present?
      for i in 0..2
        HeatMap.create(path: params[:data]["#{i}"][:path], x_coordinate: params[:data]["#{i}"][:x], y_coordinate: params[:data]["#{i}"][:y], value: 5, click_type: 'click')
      end
    end
    if params[:type] == 'move'
      HeatMap.create(path: params[:path], x_coordinate: params[:x], y_coordinate: params[:y], value: 5, click_type: 'move')
    end
  end
end
