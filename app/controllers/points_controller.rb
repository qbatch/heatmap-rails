class PointsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    if params[:data].present?
      for i in 0..2
        HeatMap.create(path: params[:data]["#{i}"][:path], click_type: 'click',xpath: params[:data]["#{i}"][:xpath])
      end
    end
    if params[:type] == 'move'
      HeatMap.create(path: params[:path], x_coordinate: params[:x], y_coordinate: params[:y], click_type: 'move')
    end
  end
end
