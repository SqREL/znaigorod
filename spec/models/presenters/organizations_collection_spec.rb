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
    before { kafe_facet.stub(:value).and_return('кафе') }
    before { kafe_facet.stub(:count).and_return(10) }
    before { meal_searcher.stub_chain(:facet, :rows).and_return([kafe_facet]) }
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
    before { meal_searcher.stub_chain(:facet, :rows).and_return([kafe_facet]) }
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

  describe 'initialize with params' do
    subject { presenter }

    context '/all/categories/foo/bar' do
      let(:params) { { category: 'all', query: 'categories/кафе/бары' } }

      its(:categories) { should == ['кафе', 'бары'] }
    end

    context '/all/categories/foo/bar/features/ololo/pysh' do
      let(:params) { { category: 'all', query: 'categories/кафе/бары/features/vip-зал/парковка' } }

      its(:categories) { should == ['кафе', 'бары'] }
      its(:features) { should == ['vip-зал', 'парковка'] }
    end

    context '/all/categories/foo/bar/features/ololo/pysh/offers/111/222/' do
      let(:params) { { category: 'all', query: 'categories/foo/bar/features/ololo/pysh/offers/обеды/завтраки/' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:features) { should == ['ololo', 'pysh'] }
      its(:offers) { should == ['обеды', 'завтраки'] }
    end

    context '/all/categories/foo/bar/cuisines/russian/asian/features/ololo/pysh/offers/111/222' do
      let(:params) { { organization_class: 'meals', category: 'all', query: 'categories/foo/bar/cuisines/русская/узбекская/features/ololo/pysh/offers/111/222' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:features) { should == ['ololo', 'pysh'] }
      its(:offers) { should == ['111', '222'] }
      its(:cuisines) { should == ['русская', 'узбекская'] }
    end

    context '/kafe/cuisines/russian/asian/features/ololo/pysh/offers/111/222' do
      let(:params) { { organization_class: 'meals', category: 'кафе', query: 'cuisines/русская/европейская/китайская/features/vip-зал/offers/обеды' } }

      its(:categories) { should == []}
      its(:features) { should == ['vip-зал'] }
      its(:offers) { should == ['обеды'] }
      its(:cuisines) { should == ['русская', 'европейская', 'китайская'] }
    end

    context '/kafe/cuisines/russian/asian/features/ololo/pysh/offers/111/222/lat/83.2342/lon/23.3434/rad/5' do
      let(:params) { { organization_class: 'meals', category: 'кафе', query: '/kafe/cuisines/russian/asian/features/ololo/pysh/offers/111/222/lat/83.2342/lon/23.3434/rad/5' } }

      its(:lat) { should == 83.2342 }
      its(:lon) { should == 23.3434 }
      its(:rad) { should == 5 }
    end
  end
end
