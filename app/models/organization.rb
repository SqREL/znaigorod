class Organization < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :address_attributes, :description, :email, :halls_attributes,
                  :images_attributes, :organization_id, :phone, :schedules_attributes,
                  :site, :title, :vfs_path, :attachments_attributes, :logotype_url

  belongs_to :organization

  has_many :affiches,       :through => :showings, :uniq => true
  has_many :halls,          :dependent => :destroy
  has_many :images,         :as => :imageable,  :dependent => :destroy
  has_many :attachments,    :as => :attachable, :dependent => :destroy
  has_many :organizations,  :dependent => :destroy
  has_many :schedules,      :dependent => :destroy
  has_many :showings,       :dependent => :destroy

  has_one :address,         :dependent => :destroy
  has_one :culture,         :dependent => :destroy
  has_one :entertainment,   :dependent => :destroy
  has_one :meal,            :dependent => :destroy

  validates_presence_of :title

  accepts_nested_attributes_for :address,   :reject_if => :all_blank
  accepts_nested_attributes_for :halls,     :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :images,    :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :attachments,    :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :schedules, :allow_destroy => true, :reject_if => :all_blank

  delegate :category, :cuisine, :feature, :offer, :payment,
           :to => :meal, :allow_nil => true, :prefix => true

  delegate :category, :feature, :offer, :payment,
           :to => :entertainment, :allow_nil => true, :prefix => true

  delegate :latitude, :longitude, :to => :address, :allow_nil => true

  scope :ordered_by_updated_at, order('updated_at DESC')
  scope :parental,              where(:organization_id => nil)

  after_save :index_additional_attributes

  alias_attribute :to_s, :title

  friendly_id :title, use: :slugged

  paginates_per Settings['pagination.per_page'] || 10

  searchable do
    float :rating
    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
    string(:kind) { 'organization' }
    text :address
    text :category,                   :more_like_this => true
    text :cuisine,                    :more_like_this => true
    text :description, :boost => 0.5
    text :email, :boost => 0.5
    text :feature,                    :more_like_this => true
    text :offer,                      :more_like_this => true
    text :payment
    text :site, :boost => 0.5
    text :term
    text :title, :boost => 2
  end

  def term
   "#{title}, #{address}"
  end

  def as_json(options)
    super(:only => :id, :methods => :term)
  end

  def nearest_affiches
    Affiche.where :id => Showing.unscoped.where('starts_at > :now AND organization_id = :organization_id',
                  { :now => DateTime.now.utc, :organization_id => id }).group(:affiche_id).pluck(:affiche_id)
  end

  def cuisine
    meal_cuisine
  end

  %w[category feature offer payment].each do |method|
    define_method method do
      [send("entertainment_#{method}"), send("meal_#{method}")].delete_if(&:blank?).compact.join(', ')
    end
  end

  %w[cuisine feature offer payment].each do |method|
    define_method "#{method}?" do
      send(method).present?
    end
  end

  def additional_attributes
    [meal, entertainment].compact
  end

  def index_additional_attributes
    additional_attributes.map(&:index)
  end

  def rating
    r = nearest_affiches.count + images.count
    r += 1 if description?
    r += 1 if email?
    r += 1 if phone?
    r / 100.0
  end

  def self.grouped_collection_for_select
    organizations = Organization.where(:organization_id => nil).order(:title)
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id              :integer          not null, primary key
#  title           :text
#  site            :text
#  email           :text
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  phone           :text
#  vfs_path        :string(255)
#  organization_id :integer
#  logotype_url    :text
#  slug            :string(255)
#

