# encoding: utf-8

require 'spec_helper'

describe OrganizationsCollection do
  let(:presenter) { OrganizationsCollection.new }

  describe "#kind_links" do
    subject { presenter.kind_links }

    its(:size) { should == 3 }

    context 'meals' do
      subject { presenter.kind_links.keys.first }

      its(:title) { should == 'Еда' }
      its(:url) { should == '/meals/all' }
    end

    context 'entertainment' do
      subject { presenter.kind_links.keys.second }

      its(:title) { should == 'Развлечения' }
      its(:url) { should == '/entertainments/all' }
    end
  end

  describe '#meal_categories' do
    let(:meal_searcher)  { HasSearcher.searcher(:meal) }
    let(:kafe_facet) { Object.new }
    before { kafe_facet.stub(:value).and_return('Кафе') }
    before { kafe_facet.stub(:count).and_return(10) }
    before { meal_searcher.stub_chain(:categories, :facet, :rows).and_return([kafe_facet]) }
    before { presenter.stub(:meal_searcher).and_return(meal_searcher) }
    subject { presenter.meal_categories }

    its(:size) { should == 1 }

    context 'first link' do
      subject { presenter.meal_categories.first }

      its(:title) { should == 'Кафе (10)' }
      its(:url) { should == '/meals/kafe' }
    end
  end
end
