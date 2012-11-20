class Creation < ActiveRecord::Base
  attr_accessible :services_attributes, :title, :description

  belongs_to :organization

  has_many :services, :as => :context, :dependent => :destroy, :order => 'id'

  accepts_nested_attributes_for :services, :reject_if => :all_blank, :allow_destroy =>  true

  delegate :images, :address, :phone, :schedules, :halls,
           :site?, :site, :email?, :email, :affiches,
           :latitude, :longitude, :nearest_affiches, :to => :organization

  delegate :touch, :title, :description, :description?, :to => :organization, :prefix => true
  after_save :organization_touch

  def self.or_facets
    %w[category]
  end

  def self.facets
    %w[category feature offer]
  end

  def self.facet_field(facet)
    "#{model_name.underscore}_#{facet}"
  end

  def category
    services.pluck(:title).uniq.compact.join(', ')
  end

  def feature
    services.pluck(:feature).uniq.compact.join(', ')
  end

  def offer
    services.pluck(:offer).uniq.compact.join(', ')
  end

  def categories
    category.split(',').map(&:squish)
  end

  def features
    feature.split(',').map(&:squish)
  end

  def offers
    offer.split(',').map(&:squish)
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
end

# == Schema Information
#
# Table name: creations
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  title           :string(255)
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
