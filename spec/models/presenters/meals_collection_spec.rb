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


end
