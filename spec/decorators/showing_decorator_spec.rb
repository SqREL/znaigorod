# encoding: utf-8
require 'spec_helper'

describe ShowingDecorator do
  let(:showing) { Showing.new(:starts_at => Time.zone.now.beginning_of_day) }
  let(:decorator) { ShowingDecorator.decorate(showing) }

  describe "#human_when" do
    subject { decorator.human_when }

    context "today" do
      it { should == "Сегодня" }
    end

    context "other day" do
      before { showing.starts_at = Time.zone.parse('2012-09-09 19:30') }

      it { should == "9 сентября в 19:30" }
    end

    context "today when set ends_at" do
      before { showing.starts_at = Time.zone.now.beginning_of_day + 9.hours }
      before { showing.ends_at = Time.zone.now.beginning_of_day + 12.hours }

      it { should == "Сегодня с 09:00 до 12:00" }
    end

    context "other day when set ands_at" do
      before { showing.starts_at = Time.zone.parse('2012-09-09 16:30') }
      before { showing.ends_at = Time.zone.parse('2012-09-09 19:30') }

      it { should == "9 сентября с 16:30 до 19:30" }
    end

    context "when starts_at and ends_at different dates" do
      before { showing.starts_at = Time.zone.parse('2012-09-09 16:30') }
      before { showing.ends_at = Time.zone.parse('2012-09-10 19:30') }

      it { should == "9 сентября 16:30 &ndash; 10 сентября 19:30" }
    end

    context "when starts_at end ends_at different dates in one month and time not set" do
      before { showing.starts_at = Time.zone.parse('2012-09-09').beginning_of_day }
      before { showing.ends_at = Time.zone.parse('2012-09-10').end_of_day }

      it { should == "9 &ndash; 10 сентября" }
    end

    context "when starts_at end ends_at different dates in different months and time not set" do
      before { showing.starts_at = Time.zone.parse('2012-09-09').beginning_of_day }
      before { showing.ends_at = Time.zone.parse('2012-10-10').end_of_day }

      it { should == "9 сентября &ndash; 10 октября" }
    end
  end

  describe "#human_price" do
    subject { decorator.human_price }
    context "when prices nil" do
      before { showing.price_min = nil }
      before { showing.price_max = nil }
      it { should == "стоимость не указана" }
    end

    context "when price_min=0 price_max=nil" do
      before { showing.price_min = 0 }
      before { showing.price_max = nil }
      it { should == "бесплатно" }
    end

    context "when set price_min" do
      before { showing.price_min = 150 }
      before { showing.price_max = nil }
      it { should == "150 руб." }
    end

    context "when set price_min and price_max" do
      before { showing.price_min = 150 }
      before { showing.price_max = 250 }
      it { should == "150 &ndash; 250 руб." }
    end

    context "when min_price = 0 and max_price > 0" do
      before { showing.price_min = 0 }
      before { showing.price_max = 150 }
      it { should == "бесплатно &ndash; 150 руб." }
    end
  end
end
