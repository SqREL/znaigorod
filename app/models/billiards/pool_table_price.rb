class PoolTablePrice < ActiveRecord::Base
  attr_accessible :day, :from, :price, :to

  belongs_to :pool_tabre

  default_scope order('day, pool_table_prices.from')

  default_value_for :day, 1

  def to_s
    "#{day} #{from} #{to} #{price}"
  end
end
