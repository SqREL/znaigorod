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
      it { should =~ /Санкт Петербург — путешествие во времени и\.\.\./ }
      it { should =~ /title=\"Санкт Петербург — путешествие во времени и пространстве\"/ }
    end
  end
end
