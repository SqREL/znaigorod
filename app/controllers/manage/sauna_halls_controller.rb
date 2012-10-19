class Manage::SaunaHallsController < Manage::ApplicationController
  actions :all, :except => :index

  belongs_to :organization do
    belongs_to :sauna, :singleton => true
  end

  def destroy
    destroy! { [:manage, @organization] }
  end
end
