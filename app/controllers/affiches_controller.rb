# encoding: utf-8

class AffichesController < ApplicationController
  layout 'public'

  def index
    if request.xhr?
      if params[:page]
        @affiche_collection = AfficheCollection.new(params.merge(list_settings: cookies['znaigorod_list_settings']))
        render partial: @affiche_collection.view_partial, layout: false and return
      end
      @affiche_today = AfficheToday.new(params[:kind])
      render :partial => 'affiche_today', :layout => false and return
    else
      @affiche_collection = AfficheCollection.new(params.merge(list_settings: cookies['znaigorod_list_settings']))
    end
  end

  def show
    @affiche = AfficheDecorator.new Affiche.find(params[:id])
  end

  def photogallery
    @affiche = AfficheDecorator.new Affiche.find(params[:id])

    render :layout => false
  end

  def trailer
    @affiche = AfficheDecorator.new Affiche.find(params[:id])

    render :layout => false
  end
end
