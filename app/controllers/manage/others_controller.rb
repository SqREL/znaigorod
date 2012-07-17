class Manage::OthersController < Manage::ApplicationController
  actions :all, :except => :show

  has_scope :page, :default => 1

  def build_resource
    super
    resource.build_affiche_schedule unless resource.affiche_schedule && resource.showings.any?
    resource
  end
end
