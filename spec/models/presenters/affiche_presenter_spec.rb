# encoding: utf-8

require 'spec_helper'

describe AffichePresenter do
  let(:affiche_presenter) { AffichePresenter.new(:kind => 'movies', :period => 'all') }
  subject { affiche_presenter }

  describe "daily" do
    context "when date set" do
      subject {AffichePresenter.new(:period => 'daily', :on => '2012-09-03')}
      its(:on) { should == Date.parse('2012-09-03') }
    end
    context "when date unset" do
      subject {AffichePresenter.new(:period => 'daily')}
      its(:on) { should == Date.today }
    end
  end

  describe "#links" do
    subject { affiche_presenter.links }
    its(:size) { should == 8 }
    describe "for movies" do
      subject { affiche_presenter.links[1] }
      its(:title) { should == "Кино" }
      its(:current?) { should == true }
      its(:url) { should == "/movies/all" }
    end
  end
end
