# encoding: utf-8
require 'spec_helper'

describe AfficheDecorator do
  let(:affiche) { Movie.new(:title => 'title') }
  before { affiche.stub(:to_param).and_return(1) }
  let(:decorator) { AfficheDecorator.new(affiche) }
  subject { decorator }
  describe "#main_page_link" do
    subject { decorator.main_page_link }
    it { should =~ /movie\/1/ }
    context "short title" do
      before { affiche.title = 'short title' }
      it { should =~ /short title/ }
    end
    context 'long title' do
      before { affiche.title = 'Санкт Петербург — путешествие во времени и пространстве' }
      it { should =~ /Санкт Петер\u00ADбург — путе\u00ADше\u00ADствие во&#160;вре\u00ADмени&#160;и&#8230;/ }
      it { should =~ /title=\"Санкт Петербург — путешествие во времени и пространстве\"/ }
    end
  end

  describe "#link" do
    subject { decorator.link }
    before { affiche.title = 'Санкт Петербург — путешествие во времени и пространстве' }
    it { should =~ /Санкт Петербург — путешествие во&#160;времени и&#160;пространстве/ }
  end

  describe "#main_page_place" do
    subject { decorator.main_page_place }
    let(:showing) { Showing.new }
    before { affiche.stub_chain(:showings, :actual).and_return([showing])  }
    before { affiche.stub_chain(:showings, :where, :first).and_return(showing) }
    context 'when showing place is string' do
      before { showing.stub(:place).and_return('Киномакс, кинотеатр') }
      it { should =~ /Кино\u00ADмакс/ }
      it { should_not =~ /href/ }
    end
    context 'when showing place long' do
      before { showing.stub(:place).and_return('Информационный центр по сильно опто коммуникационным технологиям') }
      it { should =~ /title=\"Информационный центр по&#160;сильно опто коммуникационным технологиям"/ }
      it { should =~ /Информационный центр по&#160;сильно опто/ }
    end
    context 'when showing place is_a Organization' do
      let(:organization) { Organization.new(:title => 'Киномакс, кинотеатр') }
      before { organization.stub(:to_param).and_return(1) }
      before { showing.stub(:place).and_return('Киномакс, кинотеатр') }
      before { showing.stub(:organization).and_return(organization) }
      it { should =~ /Кино\u00ADмакс/ }
      it { should =~ /organizations\/1/ }
    end
  end

  describe "#places" do
    subject { decorator.places }
    let(:showing) { Showing.new }
    before { affiche.stub_chain(:showings, :actual).and_return([showing])  }
    let(:organization) { Organization.new(:title => 'Киномакс, кинотеатр') }
    before { organization.stub(:to_param).and_return(1) }
    before { showing.stub(:place).and_return('Киномакс, кинотеатр') }
    before { showing.stub(:organization).and_return(organization) }
    its(:size) { should == 1 }
    it "array element should be PlaceDecorator" do
      subject.first.should be_a PlaceDecorator
    end
  end

  describe '#main_page_poster' do
    subject { decorator.main_page_poster }
    before { affiche.poster_url = 'http://storage.openteam.ru/files/3434/290-390/123.jpg'}
    it { should =~ /href=\"\/movie\/1\"/ }
    it { should =~ /src=\"http:\/\/storage.openteam.ru\/files\/3434\/200-268!\/123.jpg\"/ }
  end

  describe "#list_poster" do
    subject { decorator.list_poster }
    before { affiche.poster_url = 'http://storage.openteam.ru/files/3434/290-390/123.jpg'}
    it { should =~ /href=\"\/movie\/1\"/ }
    it { should =~ /src=\"http:\/\/storage.openteam.ru\/files\/3434\/180-242!\/123.jpg\"/ }
  end

  describe "#more_link" do
    subject { decorator.more_link }
    it { should =~ /movie\/1/ }
    it { should =~ /Подробнее/ }
  end

  describe "#human_distribution" do
    subject { decorator.human_distribution }
    context "when unset" do
      it { should == nil }
    end

    context "when set distribution_starts_on" do
      before { affiche.distribution_starts_on = Time.zone.parse('2012-09-05') }
      it { should == "С 5 сентября" }
    end

    context "when set distribution_starts_on and distribution_ends_on" do
      before { affiche.distribution_starts_on = Time.zone.parse('2012-09-05') }
      before { affiche.distribution_ends_on = Time.zone.parse('2012-09-15') }
      it { should == "С 5 до 15 сентября" }
    end
  end

  describe "#human_when" do
    let(:showing) { Showing.new(:starts_at => Time.zone.parse('2012-09-04 12:00')) }
    before { affiche.stub_chain(:showings, :actual).and_return([showing]) }
    subject { decorator.human_when }
    context "when distribution date set in affiche" do
      before { affiche.distribution_starts_on = Time.zone.parse('2012-09-05') }
      it { should == "С 5 сентября" }
    end

    context "when distribution date unset in affiche" do
      it { should == "4 сентября в 12:00" }
    end
  end

  describe "#affiche_distribution?" do
    subject { decorator.affiche_distribution? }
    context "when unset" do
      it { should == false }
    end

    context "when set distribution_starts_on" do
      before { affiche.distribution_starts_on = Time.zone.parse('2012-09-05') }
      it { should == true }
    end
  end

end
