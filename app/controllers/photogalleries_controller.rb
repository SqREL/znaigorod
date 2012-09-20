class PhotogalleriesController < ApplicationController
  has_scope :page, :default => 1

  def index
    @photogallery = Photogallery.new(params)
  end
end
