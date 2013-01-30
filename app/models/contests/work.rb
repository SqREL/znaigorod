class Work < ActiveRecord::Base
  attr_accessible :author_info, :image_url, :title, :description

  belongs_to :contest

  validates_presence_of :image_url

  def vfs_path
    I18n.transliterate("/znaigorod/contests/#{contest.title}").gsub(' ', '_')
  end
end

# == Schema Information
#
# Table name: works
#
#  id          :integer          not null, primary key
#  image_url   :text
#  author_info :string(255)
#  contest_id  :integer
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

