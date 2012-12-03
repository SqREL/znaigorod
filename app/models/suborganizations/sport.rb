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

  def self.or_facets
    %w[category]
  end

  def self.facets
    %w[category feature]
  end

  def self.facet_field(facet)
    "#{model_name.underscore}_#{facet}"
  end

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

  delegate :rating, :to => :organization, :prefix => true
  searchable do
    facets.each do |facet|
      text facet
      string(facet_field(facet), :multiple => true) { self.send(facet).to_s.split(',').map(&:squish).map(&:mb_chars).map(&:downcase) }
      latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
    end

    float :organization_rating
  end

  include Rating
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

