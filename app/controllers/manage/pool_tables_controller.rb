class Manage::PoolTablesController < Manage::ApplicationController
  actions :all, :except => [:index, :show]

  belongs_to :organization do
    belongs_to :billiard, :singleton => true
  end

  def destroy
    destroy! { [:manage, @organization] }
  end

  private

  #def build_nested_objects
    #(1..7).each do |day|
      #resource.sauna_hall_schedules.build(:day => day)
    #end unless resource.sauna_hall_schedules.any?
  #end
  #
  def smart_resource_url
    [:manage, @organization]
  end
end
