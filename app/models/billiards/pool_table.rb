# encoding: utf-8

class PoolTable < ActiveRecord::Base
  belongs_to :billiard
  attr_accessible :count, :size, :kind
  validates_presence_of :count, :size, :kind

  has_many :pool_table_prices, :dependent => :destroy
  accepts_nested_attributes_for :pool_table_prices, :allow_destroy => true, :reject_if => :all_blank
  attr_accessible :pool_table_prices_attributes

  def title
    "#{kind} #{size} футов"
  end
end
