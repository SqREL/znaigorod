# encoding: utf-8

class PoolTable < ActiveRecord::Base
  belongs_to :billiard
  attr_accessible :count, :size, :kind
  validates_presence_of :count, :size, :kind

  def title
    "#{kind} #{size} футов"
  end
end
