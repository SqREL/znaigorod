class Manage::MoviesController < Manage::ApplicationController
  has_scope :page, :default => 1
end
