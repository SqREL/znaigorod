# encoding: utf-8

require 'spec_helper'

describe Photogallery do
  subject { Photogallery.new }

  describe '#period' do
    context '' do
      its(:period) { should == 'all' }
    end

    context '/photogalleries/all' do
      subject { Photogallery.new period: 'week' }

      its(:period) { should == 'week' }
    end
  end

  describe '#categories' do
    context '/photogalleries/all' do
      its(:params_categories) { should be_empty }
      its(:params_tags) { should be_empty }
    end

    context '/photogalleries/all/categories/кино/кафе' do
      subject { Photogallery.new period: 'all', query: 'categories/кино/кафе' }

      its(:params_categories) { should == ['кино', 'кафе'] }
      its(:params_tags) { should be_empty }
    end
  end

  describe '#tags' do
    context '/photogalleries/all/tags/foo/bar' do
      subject { Photogallery.new period: 'all', query: 'tags/foo/bar' }

      its(:params_categories) { should be_empty }
      its(:params_tags) { should == ['foo', 'bar'] }
    end

    context '/photogalleries/all/categories/кино/кафе/tags/foo/bar' do
      subject { Photogallery.new period: 'all', query: 'categories/кино/кафе/tags/foo/bar' }

      its(:params_categories) { should == ['кино', 'кафе'] }
      its(:params_tags) { should == ['foo', 'bar'] }
    end
  end

  describe '#query_array_for_category' do
    context '/photogalleries/all/' do
      subject { Photogallery.new period: 'all' }

      it { subject.send(:query_array_for_category ,'кино').should == ['categories', 'кино'] }
    end

    context '/photogalleries/all/categories/кино' do
      subject { Photogallery.new period: 'all', query: 'categories/кино' }

      it { subject.send(:query_array_for_category, 'кино').should be_empty }
      it { subject.send(:query_array_for_category, 'концерты').should == ['categories', 'кино', 'концерты'] }
    end
  end
end
