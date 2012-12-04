class Culture < ActiveRecord::Base
  attr_accessible :category, :feature, :offer, :payment, :title, :description

  belongs_to :organization

  delegate :images, :address, :phone, :schedules, :halls,
           :site?, :site, :email?, :email, :affiches,
           :latitude, :longitude, :nearest_affiches, :to => :organization

  delegate :title, :description, :description?, to: :organization, prefix: true

  validates_presence_of :category, :organization_id

  delegate :save, to: :organization, prefix: true
  after_save :organization_save

  include Rating

  include PresentsAsCheckboxes

  presents_as_checkboxes :category,
    :available_values => -> { HasSearcher.searcher(:culture).facet(:culture_category).rows.map(&:value).map(&:mb_chars).map(&:capitalize).map(&:to_s) }

  presents_as_checkboxes :feature,
    :available_values => -> { HasSearcher.searcher(:culture).facet(:culture_feature).rows.map(&:value) }

  presents_as_checkboxes :offer,
    :available_values => -> { HasSearcher.searcher(:culture).facet(:culture_offer).rows.map(&:value) }

  include SearchWithFacets

  search_with_facets :category, :payment, :feature, :offer, :stuff
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

