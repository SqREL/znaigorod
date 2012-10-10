class Manage::RedClothController < Manage::ApplicationController
  def show
    render :text => params[:text].try(:as_html)
  end
end
