require 'spec_helper'

describe MealsCollection do
  describe 'initialize with params' do
    subject { MealsCollection.new params }

    context '/meals/categories/foo/bar' do
      let(:params) { { kind: 'meals', query: 'categories/foo/bar' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:kind) { should == 'meals' }
    end

    context '/meals/categories/foo/bar/features/ololo/pysh' do
      let(:params) { { kind: 'meals', query: 'categories/foo/bar/features/ololo/pysh' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:features) { should == ['ololo', 'pysh'] }
    end

    context '/meals/categories/foo/bar/features/ololo/pysh/offers/111/222/' do
      let(:params) { { kind: 'meals', query: 'categories/foo/bar/features/ololo/pysh/offers/111/222/' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:features) { should == ['ololo', 'pysh'] }
      its(:offers) { should == ['111', '222'] }
    end

    context '/meals/categories/foo/bar/cuisines/russian/asian/features/ololo/pysh/offers/111/222' do
      let(:params) { { kind: 'meals', query: 'categories/foo/bar/cuisines/russian/asian/features/ololo/pysh/offers/111/222' } }

      its(:categories) { should == ['foo', 'bar'] }
      its(:features) { should == ['ololo', 'pysh'] }
      its(:offers) { should == ['111', '222'] }
      its(:cuisines) { should == ['russian', 'asian'] }
    end

    context '/kafes/cuisines/russian/asian/features/ololo/pysh/offers/111/222' do
      let(:params) { { kind: 'kafes', query: 'cuisines/russian/asian/features/ololo/pysh/offers/111/222' } }

      its(:kind) { should == 'kafes' }
      its(:categories) { should == nil}
      its(:features) { should == ['ololo', 'pysh'] }
      its(:offers) { should == ['111', '222'] }
      its(:cuisines) { should == ['russian', 'asian'] }
    end
  end

end
