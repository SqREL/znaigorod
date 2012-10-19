class Manage::SaunaHallsController < Manage::ApplicationController
  actions :all, :except => :index

  #before_filter :build_resource, :only => :new
  #before_filter :build_nested_objects, :only => [:new, :edit]

  belongs_to :organization do
    belongs_to :sauna, :singleton => true
  end

  def destroy
    destroy! { [:manage, @organization] }
  end

  private

  def build_nested_objects
    (1..7).each do |day|
      resource.sauna_hall_schedules.build(:day => day)
    end unless resource.sauna_hall_schedules.any?
  end
end
