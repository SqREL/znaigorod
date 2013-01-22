class PostsController < ApplicationController
  has_scope :page, :default => 1

  def index
    @posts = Post.page(params[:page]).per(params[:per_page] || 10)
  end

  def show
    @post = Post.find(params[:id])
  end
end
