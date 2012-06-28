class GeocoderController < ApplicationController
  layout false

  def get_coordinates
    render :json => Geocoder.get_coordinates(params[:street], params[:house]) and return
  end
end

