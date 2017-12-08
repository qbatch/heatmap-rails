class PointsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    if params[:click_data].present? && params[:total_clicks].to_i > 0
      for i in 0..params[:total_clicks].to_i-1
         HeatMap.create(path: params[:click_data]["#{i}"][:path], click_type: 'click',xpath: params[:click_data]["#{i}"][:xpath])
      end
    end
    if params[:move_data].present? && params[:total_moves].to_i > 0
      for i in 0..params[:total_moves].to_i-1
        HeatMap.create(path: params[:move_data]["#{i}"][:path], click_type: 'move',xpath: params[:move_data]["#{i}"][:xpath])
      end
    end
  end
end
