# encoding: utf-8

require 'spec_helper'

describe ActualOrganizations do
  let(:actual_organizations) { ActualOrganizations.new }

  before { Time.stub!(:now).and_return(Time.local(2012, 8, 27, 11, 0)) }
  describe "#groups" do
    subject { actual_organizations.groups }
    its(:size) { should == 3 }
  end

  describe "#group #first" do
    subject { actual_organizations.groups.first }
    its(:kind) { should == :breakfast }
    its(:title) { should == 'Завтраки' }
    its(:options) { should == {:meal_offer => 'завтраки'} }
  end
end
