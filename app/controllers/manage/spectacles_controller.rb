class Manage::SpectaclesController < Manage::ApplicationController
  actions :all, :except => :show

  has_scope :page, :default => 1

  def create
    create! do |success, failure|
      failure.html { render :edit }
    end
  end

  def update
    update!{ resource_path }
  end
end
