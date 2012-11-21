class Manage::WorksController < Manage::ApplicationController
  actions :all, :except => [:index, :show]

  belongs_to :contest
end
