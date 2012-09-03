# encoding: utf-8

require 'spec_helper'

describe AffichesController do
  %w( affiches movies concerts parties spectacles exhibitions sportsevents others ).each do |kind|
    it "#index should handle /#{kind}/all/" do
      get :index, :kind => kind, :period => :all
      response.response_code.should == 200
      assigns(:affiche_presenter).kind.should eq kind
      assigns(:affiche_presenter).period.should eq 'all'
      response.should render_template('application/index')
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
    assigns(:affiche_presenter).on.should eql Date.today
  end

end
