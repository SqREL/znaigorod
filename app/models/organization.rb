class Organization < ActiveRecord::Base
  attr_accessible :address_attributes, :description, :email, :halls_attributes,
                  :images_attributes, :organization_id, :phone, :schedules_attributes,
                  :site, :title, :vfs_path

  belongs_to :organization

  has_many :affiches,       :through => :showings, :uniq => true
  has_many :halls,          :dependent => :destroy
  has_many :images,         :as => :imageable, :dependent => :destroy
  has_many :organizations,  :dependent => :destroy
  has_many :schedules,      :dependent => :destroy
  has_many :showings,       :dependent => :destroy

  has_one :entertainment,   :dependent => :destroy
  has_one :meal,            :dependent => :destroy
  has_one :address,         :dependent => :destroy

  validates_presence_of :title

  accepts_nested_attributes_for :address,   :reject_if => :all_blank
  accepts_nested_attributes_for :halls,     :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :images,    :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :schedules, :allow_destroy => true, :reject_if => :all_blank

  delegate :category, :cuisine, :feature, :offer, :payment,
           :to => :meal, :allow_nil => true, :prefix => true

  delegate :category, :feature, :offer, :payment,
           :to => :entertainment, :allow_nil => true, :prefix => true

  delegate :latitude, :longitude, :to => :address

  scope :ordered_by_updated_at, order('updated_at DESC')
  scope :parental,              where(:organization_id => nil)

  alias_attribute :to_s, :title

  searchable do
    string(:kind) { 'organization' }
    text :address
    text :category
    text :description, :boost => 0.5
    text :email, :boost => 0.5
    text :feature
    text :site, :boost => 0.5
    text :term
    text :title, :boost => 2
    text :payment
    text :offer
    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
  end

  def term
   "#{title}, #{address}"
  end

  def as_json(options)
    super(:only => :id, :methods => :term)
  end

  def nearest_affiches
    affiches.select{ |a| a.showings.where('starts_at > ?', DateTime.now.utc).any? }
  end

  def cuisine
    meal_cuisine
  end

  %w[category feature offer payment].each do |method|
    define_method method do
      [send("entertainment_#{method}"), send("meal_#{method}")].compact.join(', ')
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
end

# == Schema Information
#
# Table name: organizations
#
#  id              :integer         not null, primary key
#  title           :text
#  site            :text
#  email           :text
#  description     :text
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  phone           :text
#  vfs_path        :string(255)
#  organization_id :integer
#

