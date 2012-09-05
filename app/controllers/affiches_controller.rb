# encoding: utf-8

class AffichesController < ApplicationController
  layout 'public'

  def index
    if request.xhr?
      @affiche_today = AfficheToday.new(params[:kind])
      render :partial => 'affiche_today', :layout => false and return
    else
      @affiche_collection = AfficheCollection.new(params)
    end
  end

  def show
    render :text => "asdfsdf"
  end

end
