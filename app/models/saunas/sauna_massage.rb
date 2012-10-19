class SaunaMassage < ActiveRecord::Base
  belongs_to :sauna
  attr_accessible :anticelltilitis, :classical, :spa
end
