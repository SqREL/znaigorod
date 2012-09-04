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

  describe "#kind_links" do
    subject { affiche_presenter.kind_links }
    its(:size) { should == 8 }
    describe "for movies" do
      subject { affiche_presenter.kind_links[1] }
      its(:title) { should == "Кино" }
      its(:current?) { should == true }
      its(:url) { should == "/movies/all" }
    end
  end

  describe "#period_links" do
    before {
      searcher = HasSearcher.searcher(:affiche, :affiche_category => 'movies')
      searcher.stub_chain(:today, :group, :total).and_return(5)
      searcher.stub_chain(:weekend, :group, :total).and_return(7)
      searcher.stub_chain(:weekly, :group, :total).and_return(9)
      searcher.stub_chain(:actual, :group, :total).and_return(10)
      Counter.any_instance.stub(:searcher).and_return(searcher)
    }
    subject { affiche_presenter.period_links }
    its(:size) { should == 5 }
    describe "for daily" do
      subject { affiche_presenter.period_links[3] }
      its(:title) { should == 'Выбрать дату' }
    end
    describe "for today" do
      subject { affiche_presenter.period_links[0] }
      its(:title) { should == 'Сегодня (5)' }
    end
  end

  describe "#human_period" do
    subject { affiche_presenter.human_period }
    context 'today' do
      before { affiche_presenter.period = 'today' }
      it { should == 'Сегодня' }
    end
    context 'weekend' do
      before { affiche_presenter.period = 'weekend' }
      it { should == 'На этих выходных' }
    end
    context 'weekly' do
      before { affiche_presenter.period = 'weekly' }
      it { should == 'На этой неделе' }
    end
    context 'd)ily' do
      before { affiche_presenter.period = 'daily' }
      before { affiche_presenter.on = Date.parse('2012-09-03') }
      it { should == 'На  3 сентября' }
    end
    context 'all' do
      before { affiche_presenter.period = 'all' }
      it { should == 'Всё кино' }
    end
  end

  describe '#human_kind' do
    subject { affiche_presenter.human_kind }
    it { should == 'Кино' }
  end

  describe "#counter" do
    subject { affiche_presenter.counter }
    before {
      searcher = HasSearcher.searcher(:affiche, :affiche_category => 'movies')
      searcher.stub_chain(:today, :group, :total).and_return(5)
      Counter.any_instance.stub(:searcher).and_return(searcher)
    }
    its(:today) { should == 5 }
  end

  describe "#tag_links" do
    subject { affiche_presenter.tag_links }
    before {
      affiche_presenter.stub(:facets).and_return(%w[комедия боевик])
      affiche_presenter.stub(:tags).and_return(%w[комедия])
    }
    its(:size) { should == 2 }
    describe "selected tag" do
      subject { affiche_presenter.tag_links[0] }
      its(:title) { should == 'комедия' }
      its(:current?) { should == true }
      its(:url) { should == URI.encode('/movies/all/tags/комедия') }
    end
    describe "for non_selected tag" do
      subject { affiche_presenter.tag_links[1] }
      its(:title) { should == 'боевик' }
      its(:current?) { should == false }
      its(:url) { should == URI.encode('/movies/all/tags/комедия/боевик') }
    end
  end
end
