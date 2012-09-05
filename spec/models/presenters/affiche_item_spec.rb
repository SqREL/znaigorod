# encoding: utf-8

require 'spec_helper'

describe AfficheItem do
  let(:affiche) { Affiche.new }
  let(:showing) { Showing.new }
  let(:affiche_item) { AfficheItem.new(:affiche => affiche, :showings => [showing]) }
  subject { affiche_item }

  describe "#human_when" do
    subject { affiche_item.human_when }
    context "when distribution date set in affiche" do
      before { affiche.distribution_starts_on = Time.zone.parse('2012-09-05') }
      it { should == "С 5 сентября" }
    end

    context "when distribution date unset in affiche" do
      before { showing.starts_at = Time.zone.parse('2012-09-04 12:00') }
      it { should == "4 сентября в 12:00" }
    end
  end

  describe "#affiche_distribution?" do
    subject { affiche_item.affiche_distribution? }
    context "when unset" do
      it { should == false }
    end

    context "when set distribution_starts_on" do
      before { affiche.distribution_starts_on = Time.zone.parse('2012-09-05') }
      it { should == true }
    end
  end
end
