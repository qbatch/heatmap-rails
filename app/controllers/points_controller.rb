class PointsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    if params[:data].present?
      for i in 0..Heatmap::Rails.options[:click]-1
        HeatMap.create(path: params[:data]["#{i}"][:path], click_type: 'click',xpath: params[:data]["#{i}"][:xpath])
      end
    end
    if params[:move_data].present?
      for i in 0..Heatmap::Rails.options[:move]-1
        HeatMap.create(path: params[:move_data]["#{i}"][:path], click_type: 'click',xpath: params[:move_data]["#{i}"][:xpath])
      end
    end
  end
end
