# encoding: utf-8

require 'spec_helper'

describe OrganizationsCollection do
  let(:presenter) { OrganizationsCollection.new params }

  describe "#kind_links" do
    let(:params) {{}}
    subject { presenter.kind_links }

    its(:size) { should == 3 }

    context 'meals' do
      subject { presenter.kind_links.keys.first }

      its(:title) { should == 'Еда' }
      its(:url) { should == '/meals' }
    end

    context 'entertainment' do
      subject { presenter.kind_links.keys.second }

      its(:title) { should == 'Развлечения' }
      its(:url) { should == '/entertainments' }
    end
  end

  describe '#meal_categories_links' do
    let(:params) {{}}
    let(:meal_searcher)  { HasSearcher.searcher(:meal) }
    let(:kafe_facet) { Object.new }
    before { kafe_facet.stub(:value).and_return('Кафе') }
    before { kafe_facet.stub(:count).and_return(10) }
    before { meal_searcher.stub_chain(:categories, :facet, :rows).and_return([kafe_facet]) }
    before { presenter.stub(:meal_searcher).and_return(meal_searcher) }
    subject { presenter.meal_categories_links }

    its(:size) { should == 1 }

    context 'first link' do
      subject { presenter.meal_categories_links.first }

      its(:title) { should == 'Кафе (10)' }
      its(:url) { should == URI.encode('/meals/кафе') }
    end
  end

  describe '#view' do
    subject { presenter.view }
    context 'for organizations catalog' do
      let(:params) {{ :organization_class => 'organizations' }}
      it { should == 'catalog' }
    end

    context 'for list organizations' do
      let(:params) {{ :organization_class => 'meals' }}
      it { should == 'index' }
    end
  end

  describe "#class_categories_links" do
    let(:params) { { organization_class: 'meals'}  }
    let(:meal_searcher)  { HasSearcher.searcher(:meal) }
    let(:kafe_facet) { Object.new }
    before { kafe_facet.stub(:value).and_return('Кафе') }
    before { kafe_facet.stub(:count).and_return(175) }
    before { meal_searcher.stub_chain(:categories, :facet, :rows).and_return([kafe_facet]) }
    before { presenter.stub(:meal_searcher).and_return(meal_searcher) }

    subject { presenter.class_categories_links }

    its(:size) { should == 2 }

    context "when kind all" do
      subject { presenter.class_categories_links.first }
      its(:title) { should == 'Все заведения питания'}
      its(:url) { should == '/meals' }
      its(:current) { should == true }
    end
  end

  describe "#title" do
    subject { presenter.title }
    context 'organizations' do
      let(:params) {{ organization_class: 'organizations' }}
      it { should == 'Заведения города' }
    end

  end
end
