class SaunaMassage < ActiveRecord::Base
  belongs_to :sauna
  attr_accessible :anticelltilitis, :classical, :spa
end

# == Schema Information
#
# Table name: sauna_massages
#
#  id              :integer          not null, primary key
#  sauna_id        :integer
#  classical       :integer
#  spa             :integer
#  anticelltilitis :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

