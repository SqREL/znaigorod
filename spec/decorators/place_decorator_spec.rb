# encoding: utf-8

require 'spec_helper'

describe PlaceDecorator do
  describe "#place" do
    subject { place.place }
    context "for organization" do
      let(:organization) { Organization.new }
      before { organization.stub(:title).and_return('Киномир, кинотеатр') }
      before { organization.stub(:to_param).and_return('22') }
      before { organization.stub(:address).and_return('пр. Ленина, 40') }
      before { organization.stub(:latitude).and_return('56.499342513322') }
      before { organization.stub(:longitude).and_return('84.996124274238') }
      let(:place) { PlaceDecorator.new(:organization => organization) }
      it { should =~ /Киномир, кинотеатр<\/a>/ }
      it { should =~ /title=\"Киномир, кинотеатр\"/ }
      it { should =~ /organizations\/22/ }
      it { should =~ /пр. Ленина, 40<\/a>/ }
      it { should =~ /latitude=\"56.499342513322\"/ }
      it { should =~ /longitude=\"84.996124274238\"/ }
    end

    context "for place" do
      let(:place) { PlaceDecorator.new(:title => "пл. Ленина", :latitude => '56.499342513322', :longitude => '84.996124274238') }
      it { should =~ /пл. Ленина/ }
      it { should_not =~ /organizations/ }
      it { should =~ /показать на карте<\/a>/ }
      it { should =~ /latitude=\"56.499342513322\"/ }
      it { should =~ /longitude=\"84.996124274238\"/ }
    end
  end
end
