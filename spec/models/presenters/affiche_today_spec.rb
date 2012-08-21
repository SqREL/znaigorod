# encoding: utf-8

require 'spec_helper'

describe AfficheToday do
  subject { AfficheToday.new }

  describe "#default_kind" do
    context "sunday 11:00" do
      before { Time.stub!(:now).and_return(Time.local(2012, 8, 19, 11, 0)) }
      its(:kind) { should == 'Exhibition'}
    end
  end
end
