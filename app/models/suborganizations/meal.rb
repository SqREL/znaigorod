class Meal < ActiveRecord::Base
  attr_accessible :category, :cuisine, :feature, :offer, :payment, :title, :description

  belongs_to :organization

  delegate :images, :address, :phone, :schedules, :halls,
           :site?, :site, :email?, :email, :affiches,
           :latitude, :longitude, :nearest_affiches, :to => :organization

  delegate :title, :description, :description?, :touch, to: :organization, prefix: true

  validates_presence_of :category, :organization_id

  after_save :organization_touch

  def self.facets
    %w[category payment cuisine feature offer]
  end

  def self.or_facets
    %w[categories cuisine]
  end

  def self.facet_field(facet)
    "#{model_name.underscore}_#{facet}"
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

  def cuisines
    cuisine.split(',').map(&:squish)
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
# Table name: meals
#
#  id              :integer          not null, primary key
#  category        :text
#  feature         :text
#  offer           :text
#  payment         :string(255)
#  cuisine         :text
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string(255)
#  description     :text
#

