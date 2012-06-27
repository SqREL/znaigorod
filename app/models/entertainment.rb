class Entertainment < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :category, :feature, :offer, :payment
end
# == Schema Information
#
# Table name: entertainments
#
#  id              :integer         not null, primary key
#  category        :text
#  feature         :text
#  offer           :text
#  payment         :string(255)
#  organization_id :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

