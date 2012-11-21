class Contest < ActiveRecord::Base
  attr_accessible :description, :ends_on, :starts_on, :title

  has_many :works, :dependent => :destroy

  validates_presence_of :title
end

# == Schema Information
#
# Table name: contests
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  starts_on   :date
#  ends_on     :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

