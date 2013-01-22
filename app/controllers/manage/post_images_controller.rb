class Manage::PostImagesController < Manage::ApplicationController
  actions :new, :create, :destroy, :update, :edit

  belongs_to :post, :polymorphic => true, :optional => true
end
