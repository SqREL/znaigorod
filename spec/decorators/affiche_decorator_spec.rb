# encoding: utf-8
require 'spec_helper'

describe AfficheDecorator do
  let(:affiche) { Affiche.new(:title => 'title') }
  before { affiche.stub(:to_param).and_return(1) }
  let(:decorator) { AfficheDecorator.decorate(affiche) }
  subject { decorator }
  describe "#link" do
    subject { decorator.link }
    it { should =~ /affiches\/1/ }
    context "short title" do
      before { affiche.title = 'short title' }
      it { should =~ /short title/ }
    end
    context 'long title' do
      before { affiche.title = 'Санкт Петербург — путешествие во времени и пространстве' }
      it { should =~ /Санкт Петер\u00ADбург — путе\u00ADше\u00ADствие во вре\u00ADмени и\.\.\./ }
      it { should =~ /title=\"Санкт Петербург — путешествие во времени и пространстве\"/ }
    end
  end

  describe "#place" do
    subject { decorator.place }
    let(:showing) { Showing.new }
    before { affiche.stub(:showings).and_return([showing])  }
    context 'when showing place is string' do
      before { showing.stub(:place).and_return('Киномакс, кинотеатр') }
      it { should == 'Киномакс' }
    end
    context 'when showing place long' do
      before { showing.stub(:place).and_return('Информационный центр по сильно опто коммуникационным технологиям') }
      it { should =~ /title=\"Информационный центр по сильно опто коммуникационным технологиям"/ }
      it { should =~ /Информационный центр по сильно опто/ }
    end
  end

  describe '#poster' do
    subject { decorator.poster }
    before { affiche.poster_url = 'http://storage.openteam.ru/files/3434/290-390/123.jpg'}
    it { should =~ /href=\"\/affiches\/1\"/ }
    it { should =~ /src=\"http:\/\/storage.openteam.ru\/files\/3434\/200-268!\/123.jpg\"/ }
  end
end
