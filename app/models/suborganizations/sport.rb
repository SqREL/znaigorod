class Sport < ActiveRecord::Base
  attr_accessible :services_attributes, :title, :description

  belongs_to :organization

  has_many :services, :as => :context, :dependent => :destroy

  accepts_nested_attributes_for :services, :reject_if => :all_blank, :allow_destroy =>  true

  delegate :title, :to => :organization
end

# == Schema Information
#
# Table name: sports
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  title           :string(255)
#  description     :text
#

