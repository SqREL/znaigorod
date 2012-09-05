# encoding: utf-8

require 'spec_helper'

describe AffichesController do
    before {
      AfficheCollection.any_instance.stub(:paginated_affiches).and_return([])
    }
  %w( affiches movies concerts parties spectacles exhibitions sportsevents others ).each do |kind|
    it "#index should handle /#{kind}/all/" do
      get :index, :kind => kind, :period => :all
      response.response_code.should == 200
      assigns(:affiche_collection).kind.should eq kind
      assigns(:affiche_collection).period.should eq 'all'
      response.should render_template('affiches/index')
    end
  end



  %w( movies concerts parties spectacles exhibitions sportsevents others ).each do |kind|
    it "#index should handle /#{kind}/today/ with xhr request" do
      xhr :get, :index, :kind => kind, :period => :today
      assigns(:affiche_today).kind.should eq kind
      response.should render_template('affiches/_affiche_today')
    end
  end

  it "#index should get :on for daily affiches" do
    get :index, :kind => 'movies', :period => 'daily', :on => Date.today
    assigns(:affiche_collection).on.should eql Date.today
  end

  describe "with tags" do
    it "for daily when set on" do
      get :index, :kind => 'movies', :period => 'daily', :on => Date.today, :tags => "познавательно/для девушек"
      assigns(:affiche_collection).tags.should eql ['познавательно', 'для девушек']
    end
    it "for today" do
      get :index, :kind => 'movies', :period => 'today', :tags => "познавательно/для девушек"
      assigns(:affiche_collection).tags.should eql ['познавательно', 'для девушек']
    end
  end

end
