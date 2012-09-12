# encoding: utf-8

require 'spec_helper'

describe MealsCollection do

  let(:presenter) { MealsCollection.new params }

  describe 'initialize with params' do
    subject { presenter }

    context '/all/categories/foo/bar' do
      let(:params) { { kind: 'all', query: 'categories/foo/bar' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:kind) { should == 'all' }
    end

    context '/all/categories/foo/bar/features/ololo/pysh' do
      let(:params) { { kind: 'all', query: 'categories/foo/bar/features/ololo/pysh' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:features) { should == ['ololo', 'pysh'] }
    end

    context '/all/categories/foo/bar/features/ololo/pysh/offers/111/222/' do
      let(:params) { { kind: 'all', query: 'categories/foo/bar/features/ololo/pysh/offers/111/222/' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:features) { should == ['ololo', 'pysh'] }
      its(:offers) { should == ['111', '222'] }
    end

    context '/all/categories/foo/bar/cuisines/russian/asian/features/ololo/pysh/offers/111/222' do
      let(:params) { { kind: 'all', query: 'categories/foo/bar/cuisines/russian/asian/features/ololo/pysh/offers/111/222' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:features) { should == ['ololo', 'pysh'] }
      its(:offers) { should == ['111', '222'] }
      its(:cuisines) { should == ['russian', 'asian'] }
    end

    context '/kafe/cuisines/russian/asian/features/ololo/pysh/offers/111/222' do
      let(:params) { { kind: 'kafe', query: 'cuisines/russian/asian/features/ololo/pysh/offers/111/222' } }

      its(:kind) { should == 'kafe' }
      its(:categories) { should == nil}
      its(:features) { should == ['ololo', 'pysh'] }
      its(:offers) { should == ['111', '222'] }
      its(:cuisines) { should == ['russian', 'asian'] }
    end
  end

  describe "#link_categories" do
    let(:params) { { kind: 'all'}  }
    let(:meal_searcher)  { HasSearcher.searcher(:meal) }
    let(:kafe_facet) { Object.new }
    before { kafe_facet.stub(:value).and_return('Кафе') }
    before { kafe_facet.stub(:count).and_return(175) }
    before { meal_searcher.stub_chain(:categories, :facet, :rows).and_return([kafe_facet]) }
    before { presenter.stub(:meal_searcher).and_return(meal_searcher) }

    subject { presenter.link_categories }

    its(:size) { should == 2 }

    context "when kind all" do
      subject { presenter.link_categories.first }
      its(:title) { should == 'Все заведения питания'}
      its(:current) { should == true }
    end
  end

end
