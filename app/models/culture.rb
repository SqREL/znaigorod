class Culture < ActiveRecord::Base
  attr_accessible :category, :feature, :offer, :payment

  belongs_to :organization

  delegate :title, :images, :address, :phone, :schedules, :halls,
           :site?, :site, :email?, :email, :description, :description?, :affiches,
           :latitude, :longitude, :nearest_affiches, :to => :organization

  validates_presence_of :category, :organization_id

  def self.or_facets
    %w[category]
  end

  def self.facets
    %w[category payment feature offer]
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

  delegate :rating, :to => :organization, :prefix => true
  searchable do
    facets.each do |facet|
      text facet
      string(facet_field(facet), :multiple => true) { self.send(facet).to_s.split(',').map(&:squish).map(&:mb_chars).map(&:downcase) }
      latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
    end

    float :organization_rating, :stored => true
  end
end

# == Schema Information
#
# Table name: cultures
#
#  id              :integer          not null, primary key
#  category        :text
#  feature         :text
#  offer           :text
#  payment         :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
