# encoding: utf-8

require 'spec_helper'

describe AfficheCollection do
  let(:params) { { kind: 'movies', period: 'all' } }
  let(:affiche_collection) { AfficheCollection.new(params) }
  subject { affiche_collection }

  describe "daily" do
    context "when date set" do
      subject {AfficheCollection.new(:period => 'daily', :on => '2012-09-03')}
      its(:on) { should == Date.parse('2012-09-03') }
    end
    context "when date unset" do
      subject {AfficheCollection.new(:period => 'daily')}
      its(:on) { should == Date.today }
    end
  end

  describe "#kind_links" do
    subject { affiche_collection.kind_links }
    its(:size) { should == 9 }
    describe "for movies" do
      subject { affiche_collection.kind_links[1] }
      its(:title) { should == "Кино" }
      its(:current?) { should == true }
      its(:url) { should == "/movies/all" }
    end
  end

  describe "#period_links" do
    before {
      searcher = HasSearcher.searcher(:affiche, :affiche_category => 'movies')
      searcher.stub_chain(:today, :actual, :affiches, :group, :total).and_return(5)
      searcher.stub_chain(:weekend, :actual, :affiches, :group, :total).and_return(7)
      searcher.stub_chain(:weekly, :actual, :affiches, :group, :total).and_return(9)
      searcher.stub_chain(:actual, :affiches, :group, :total).and_return(10)
      Counter.any_instance.stub(:searcher).and_return(searcher)
    }
    subject { affiche_collection.period_links }
    its(:size) { should == 5 }
    describe "for daily" do
      subject { affiche_collection.period_links[3] }
      its(:title) { should == 'Выбрать дату' }
    end
    describe "for today" do
      subject { affiche_collection.period_links[0] }
      its(:title) { should == 'Сегодня&nbsp;(5)' }
    end
  end

  describe "#human_period" do
    subject { affiche_collection.human_period }
    context 'today' do
      before { affiche_collection.period = 'today' }
      it { should == 'Сегодня' }
    end
    context 'weekend' do
      before { affiche_collection.period = 'weekend' }
      it { should == 'На этих выходных' }
    end
    context 'weekly' do
      before { affiche_collection.period = 'weekly' }
      it { should == 'На этой неделе' }
    end
    context 'daily' do
      before { affiche_collection.period = 'daily' }
      before { affiche_collection.on = Date.parse('2012-09-03') }
      it { should == ' 3 сентября' }
    end
    context 'all' do
      before { affiche_collection.period = 'all' }
      it { should == '' }
    end
  end

  describe '#human_kind' do
    subject { affiche_collection.human_kind }
    it { should == 'Всё кино' }
  end

  describe "#counter" do
    subject { affiche_collection.counter }
    before {
      searcher = HasSearcher.searcher(:affiche, :affiche_category => 'movies')
      searcher.stub_chain(:today, :actual, :affiches, :group, :total).and_return(5)
      Counter.any_instance.stub(:searcher).and_return(searcher)
    }
    its(:today) { should == 5 }
  end

  describe "#tag_links" do
    subject { affiche_collection.tag_links }
    before {
      affiche_collection.stub(:all_tags).and_return(%w[приключения комедия боевик])
      affiche_collection.stub(:tags).and_return(%w[комедия])
    }
    its(:size) { should == 3 }
    describe "selected tag" do
      subject { affiche_collection.tag_links[1] }
      its(:title) { should == 'комедия' }
      its(:current?) { should == true }
      its(:url) { should == '/movies/all' }
    end
    describe "for non_selected tag" do
      subject { affiche_collection.tag_links[2] }
      its(:title) { should == 'боевик' }
      its(:current?) { should == false }
      its(:url) { should == URI.encode('/movies/all/tags/комедия/боевик') }
    end
  end

  describe "#searcher_scopes" do
    subject { affiche_collection.searcher_scopes }
    context "when today" do
      before { affiche_collection.period = 'today' }
      it { should == ['today', 'actual', 'order_by_affiche_popularity'] }
    end
    context "when daily and date = today" do
      before { affiche_collection.period = 'daily' }
      before { affiche_collection.on = Date.today }
      it { should == ['today', 'order_by_affiche_popularity'] }
    end
    context "when daily and date != today" do
      before { affiche_collection.period = 'daily' }
      before { affiche_collection.on = Date.today + 3.days }
      it { should == ['order_by_affiche_popularity'] }
    end
    context "when weekly" do
      before { affiche_collection.period = 'weekly' }
      it { should == ['weekly', 'actual', 'order_by_affiche_popularity'] }
    end
    context "when weekend" do
      before { affiche_collection.period = 'weekend' }
      it { should == ['weekend', 'actual', 'order_by_affiche_popularity'] }
    end
    context "when all" do
      before { affiche_collection.period = 'all' }
      it { should == ['actual', 'order_by_affiche_popularity'] }
    end
  end

  describe "#presentation_mode" do
    subject { affiche_collection.presentation_mode }
    context 'when unset' do
      it { should == 'list' }
    end
    context 'when set posters' do
      let(:params) {{ kind: 'movies', period: 'all', list_settings: "{\"sort\":[\"closest\"],\"presentation\":\"posters\"}" }}
      it { should == 'posters' }
    end
  end

end
