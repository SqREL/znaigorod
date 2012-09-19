# encoding: utf-8

class OrganizationsController < ApplicationController
  has_scope :page, :default => 1

  def index
    @organizations_collection = OrganizationsCollection.new params

    render @organizations_collection.view
  end

  def show
    @organization = OrganizationDecorator.find(params[:id])
  end

  def photogallery
    @organization = OrganizationDecorator.find(params[:id])
    render :layout => false
  end

  def affiche
    @organization = OrganizationDecorator.find(params[:id])
    render :layout => false
  end
end
