class Image < ActiveRecord::Base
  attr_accessible :description, :url, :thumbnail_url

  belongs_to :imageable, :polymorphic => true

  default_scope :order => :id

  validates_presence_of :description, :url

  after_create :index_imageable
  after_destroy :index_imageable

  searchable do
    integer :id
    string :imageable_type
    string(:imageable_id_str) { imageable_id.to_s }
    string :category
    string :tags, :multiple => true
    text :description
    time :created_at
  end

  private

  def index_imageable
    imageable.index_additional_attributes if imageable.respond_to? :index_additional_attributes
  end

  def category
    imageable.class.model_name.human.mb_chars.downcase
  end

  def tags
    imageable.respond_to?(:tags) ? imageable.tags : []
  end
end

# == Schema Information
#
# Table name: images
#
#  id             :integer         not null, primary key
#  url            :text
#  imageable_id   :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  description    :text
#  imageable_type :string(255)
#

