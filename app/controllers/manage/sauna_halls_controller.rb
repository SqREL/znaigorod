class Manage::SaunaHallsController < Manage::ApplicationController
  actions :all, :except => [:index, :show]

  belongs_to :organization do
    belongs_to :sauna, :singleton => true
  end

  def create
    create! { [:manage, @organization] }
  end

  def destroy
    destroy! { [:manage, @organization] }
  end

  def update
    update! { [:manage, @organization] }
  end
end
