# encoding: utf-8

class OrganizationsController < ApplicationController
  has_scope :page, :default => 1

  def index
    @organizations_collection = OrganizationsCollection.new params
    render partial: 'organizations_list', layout: false and return if request.xhr?
    render @organizations_collection.view
  end

  def show
    @organization = OrganizationDecorator.find(params[:id])
    @affiche_collection = AfficheCollection.new(params.merge(list_settings: cookies['znaigorod_affiches_list_settings']).merge(organization: @organization))
    render partial: @affiche_collection.view_partial, layout: false and return if request.xhr?
  end

  def photogallery
    @organization = OrganizationDecorator.find(params[:id])
  end

  def affiche
    @organization = OrganizationDecorator.find(params[:id])
    @affiche_collection = AfficheCollection.new(params.merge(list_settings: cookies['znaigorod_affiches_list_settings']).merge(organization: @organization))
    render partial: @affiche_collection.view_partial, layout: false and return if request.xhr?
  end

  def tour
    @organization = OrganizationDecorator.find(params[:id])
  end
end
