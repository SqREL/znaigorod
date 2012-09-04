# encoding: utf-8
require 'spec_helper'

describe ShowingDecorator do
  let(:showing) { Showing.new }
  let(:decorator) { ShowingDecorator.decorate(showing) }

  describe "#human_when" do
    subject { decorator.human_when }
    context "today" do
      before { showing.starts_at = DateTime.now.beginning_of_day }
      it { should == "Сегодня" }
    end
    context "other day" do
      before { showing.starts_at = DateTime.new(2012, 9, 9, 12, 30) }
      it { should == "9 сентября в 19:30" }
    end
  end
end
