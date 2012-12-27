class Post < ActiveRecord::Base
  extend FriendlyId
<<<<<<< HEAD

  attr_accessible :annotation, :content, :poster_url, :title, :vfs_path

  validates_presence_of :annotation, :content, :title

  friendly_id :title, use: :slugged

  def self.generate_vfs_path
    "/znaigorod/posts/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end
=======
  attr_accessible :annotation, :content, :poster_url, :title, :vfs_path

  validates_presence_of :annotation
  validates_presence_of :content
  validates_presence_of :title

  friendly_id :title, use: :slugged
>>>>>>> Add Post model and initial CRUD
end
