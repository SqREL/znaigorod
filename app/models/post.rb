class Post < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :annotation, :content, :poster_url, :title, :vfs_path

  validates_presence_of :annotation
  validates_presence_of :content
  validates_presence_of :title

  friendly_id :title, use: :slugged
end
