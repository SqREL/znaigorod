class PostImage < ActiveRecord::Base
  belongs_to :post
  attr_accessible :title, :attachment

  has_attached_file :attachment, :storage => :elvfs, :elvfs_url => Settings['storage.url']
end
