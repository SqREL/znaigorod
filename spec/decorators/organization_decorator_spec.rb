# encoding: utf-8
require 'spec_helper'

describe OrganizationDecorator do
  let(:org) { Organization.new(:title => 'title') }
  #before { affiche.stub(:to_param).and_return(1) }
  let(:decorator) { OrganizationDecorator.new(org) }

  describe "#schedule_day_names" do
    subject { decorator.schedule_day_names(days) }
    context "for [7]" do
      let(:days) { [7] }
      it { should == "Вс" }
    end
    context "for [6, 7]" do
      let(:days) { [6, 7] }
      it { should == "Сб, Вс" }
    end
    context "for [1, 2, 3, 4]" do
      let(:days) { [1, 2, 3, 4] }
      it { should == "Пн - Чт" }
    end
    context "for [1, 3, 4]" do
      let(:days) { [1, 3, 4] }
      it { should == "Пн, Ср, Чт" }
    end
    context "for [1, 3, 4, 5, 6]" do
      let(:days) { [1, 3, 4, 5, 6] }
      it { should == "Пн, Ср - Сб" }
    end
  end

end
