class Billiard < Entertainment
  has_many :pool_tables, :dependent => :destroy

  include Rating
end

# == Schema Information
#
# Table name: entertainments
#
#  id              :integer          not null, primary key
#  category        :text
#  feature         :text
#  offer           :text
#  payment         :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string(255)
#  description     :text
#  type            :string(255)
#

