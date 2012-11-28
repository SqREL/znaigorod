class Culture < ActiveRecord::Base
  attr_accessible :category, :feature, :offer, :payment, :title, :description

  belongs_to :organization

  delegate :images, :address, :phone, :schedules, :halls,
           :site?, :site, :email?, :email, :affiches,
           :latitude, :longitude, :nearest_affiches, :to => :organization

  delegate :title, :description, :description?, to: :organization, prefix: true

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

  include PresentsAsCheckboxes

  presents_as_checkboxes :category,
    :available_values => -> { HasSearcher.searcher(:culture).facet(:culture_category).rows.map(&:value).map(&:mb_chars).map(&:capitalize).map(&:to_s) }

  presents_as_checkboxes :feature,
    :available_values => -> { HasSearcher.searcher(:culture).facet(:culture_feature).rows.map(&:value) }

  presents_as_checkboxes :offer,
    :available_values => -> { HasSearcher.searcher(:culture).facet(:culture_offer).rows.map(&:value) }
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
#  title           :string(255)
#  description     :text
#

