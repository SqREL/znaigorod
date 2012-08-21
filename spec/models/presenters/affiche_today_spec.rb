# encoding: utf-8

require 'spec_helper'

describe AfficheToday do
  let(:affiche_today) { AfficheToday.new }
  subject { affiche_today }

  before { Time.stub!(:now).and_return(Time.local(2012, 8, 19, 11, 0)) }
  describe "#default_kind" do
    context "sunday 11:00" do
      its(:kind) { should == 'Exhibition'}
    end
  end

  describe "#links" do
    subject { affiche_today.links }
    its(:size) { should == 7 }
    describe "for Exhibition" do
      subject { affiche_today.links[4] }
      its(:title) { should == "Выставки" }
      its(:current?) { should == true }
    end
  end

  describe "#counters" do
    subject { affiche_today.counters }
    its(:size) { should == 7 }
    describe "for Exhebition" do
      subject { affiche_today.counters[Exhibition] }
      before {
        searcher = HasSearcher.searcher(:affiche, :affiche_category => 'exhibition')
        searcher.stub_chain(:today, :group, :total).and_return(5)
        Counter.any_instance.stub(:searcher).and_return(searcher)
      }
      its(:today) { should == 5 }
    end
  end

end
