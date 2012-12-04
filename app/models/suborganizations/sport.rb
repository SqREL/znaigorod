class Sport < ActiveRecord::Base
  attr_accessible :services_attributes, :title, :description

  belongs_to :organization

  has_many :services, :as => :context, :dependent => :destroy, :order => 'id'

  delegate :images, :address, :phone, :schedules, :halls,
           :site?, :site, :email?, :email, :affiches,
           :latitude, :longitude, :nearest_affiches, :to => :organization

  delegate :title, :description, :description?, :to => :organization, :prefix => true

  accepts_nested_attributes_for :services, :reject_if => :all_blank, :allow_destroy =>  true

  delegate :save, to: :organization, prefix: true
  after_save :organization_save

  def category
    services.pluck(:category).compact.uniq.join(', ')
  end

  def feature
    services.pluck(:feature).compact.uniq.join(', ')
  end

  def categories
    category.split(',').map(&:squish).uniq
  end

  def features
    feature.split(',').map(&:squish).uniq
  end

  include Rating

  include SearchWithFacets

  search_with_facets :category, :feature, :stuff
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

