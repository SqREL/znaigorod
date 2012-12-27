class Post < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :annotation, :content, :poster_url, :title, :vfs_path

  validates_presence_of :annotation, :content, :title

  friendly_id :title, use: :slugged

  def self.generate_vfs_path
    "/znaigorod/posts/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end
end
