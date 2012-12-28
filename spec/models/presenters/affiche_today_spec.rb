# encoding: utf-8

require 'spec_helper'

describe AfficheToday do
  let(:affiche_today) { AfficheToday.new }
  subject { affiche_today }

  before { Time.stub!(:now).and_return(Time.local(2012, 9, 17, 3, 0)) }
  describe "#default_kind" do
    context "monday 03:00" do
      its(:kind) { should == 'parties'}
    end
  end

  describe "#links" do
    subject { affiche_today.links }
    its(:size) { should == 8 }
    describe "for Parties" do
      subject { affiche_today.links[2] }
      its(:title) { should == "Вечеринки" }
      its(:current?) { should == true }
      its(:url) { should == "/parties/today" }
    end
  end

  describe "#counters" do
    subject { affiche_today.counters }
    its(:size) { should == 8 }
    describe "for Exhebition" do
      subject { affiche_today.counters['exhibitions'] }
      before {
        searcher = HasSearcher.searcher(:affiche, :affiche_category => 'exhibition')
        searcher.stub_chain(:today, :actual, :affiches, :group, :total).and_return(5)
        Counter.any_instance.stub(:searcher).and_return(searcher)
      }
      its(:today) { should == 5 }
    end
  end

end
