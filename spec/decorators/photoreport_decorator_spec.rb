# encoding: utf-8
require 'spec_helper'

describe PhotoreportDecorator do
  let(:affiche) { Movie.new(:title => 'title') }
  let(:image) { Image.new(:url => 'http://storage.openteam.ru/files/3434/290-390/123.jpg') }
  before { affiche.stub(:to_param).and_return(1) }
  before { affiche.stub(:images).and_return([image]) }
  let(:decorator) { PhotoreportDecorator.decorate(affiche) }

  describe "#date" do
    subject { decorator.date }
    before { image.stub(:created_at).and_return(DateTime.new(2012, 8, 24, 12, 7, 0))  }
    it { should == '24 августа' }
  end

  describe "#images_count" do
    subject { decorator.images_count }
    before { affiche.stub_chain(:images, :count).and_return(3) }
    it { should == 3 }
  end

  describe "#main_images" do
    subject { decorator.main_images }
    before { affiche.stub_chain(:images, :limit).and_return([image]) }
    it { should =~ /href=\"\/movie\/1\"/ }
    it { should =~ /src=\"http:\/\/storage.openteam.ru\/files\/3434\/220-220\/123.jpg\"/ }
  end

end
