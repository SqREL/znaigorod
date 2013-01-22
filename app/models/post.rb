class Post < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :annotation, :content, :poster_url, :title, :vfs_path

  has_many :post_images

  validates_presence_of :annotation, :content, :title

  friendly_id :title, use: :slugged

  def self.generate_vfs_path
    "/znaigorod/posts/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end

  searchable do
    text :title,                :more_like_this => true
    text :annotation,           :more_like_this => true
    text :content,              :more_like_this => true
  end

  def similar_posts
    HasSearcher.searcher(:similar_posts).more_like_this(self).limit(3).results
  end
end
