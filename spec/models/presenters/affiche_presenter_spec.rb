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

  describe "#human_period" do
    subject { affiche_presenter.human_period }
    context 'today' do
      before { affiche_presenter.period = 'today' }
      it { should == 'сегодня' }
    end
    context 'weekend' do
      before { affiche_presenter.period = 'weekend' }
      it { should == 'на этих выходных' }
    end
    context 'weekly' do
      before { affiche_presenter.period = 'weekly' }
      it { should == 'на этой неделе' }
    end
    context 'daily' do
      before { affiche_presenter.period = 'daily' }
      before { affiche_presenter.on = Date.parse('2012-09-03') }
      it { should == 'на  3 сентября' }
    end
  end

  describe '#human_kind' do
    subject { affiche_presenter.human_kind }
    it { should == 'Кино' }
  end
end
