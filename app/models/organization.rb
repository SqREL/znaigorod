class Organization < ActiveRecord::Base
  attr_accessible :address_attributes,
                  :description,
                  :email,
                  :halls_attributes,
                  :images_attributes,
                  :organization_id,
                  :phone,
                  :schedules_attributes,
                  :site,
                  :title,
                  :vfs_path

  has_one :entertainment, :dependent => :destroy
  has_one :meal, :dependent => :destroy
  has_many :organizations, :dependent => :destroy
  belongs_to :organization

  has_many :halls, :dependent => :destroy
  has_many :images, :dependent => :destroy
  has_many :schedules, :dependent => :destroy
  has_many :showings, :dependent => :destroy
  has_many :affiches, :through => :showings, :uniq => true

  has_one :address, :dependent => :destroy

  validates_presence_of :title

  accepts_nested_attributes_for :address, :reject_if => :all_blank
  accepts_nested_attributes_for :halls, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :schedules, :allow_destroy => true, :reject_if => :all_blank

  scope :ordered_by_updated_at, ->(param) { order('updated_at DESC') }

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

    boost 45
  end

  def to_s
    title
  end

  def term
   "#{title}, #{address}"
  end

  def as_json(options)
    super(:only => :id, :methods => :term)
  end

  def nearest_affiches
    affiches.select{ |a| a.showings.where('starts_at > ?', Date.today).any? }
  end

  delegate :category, :feature, :offer, :payment, :to => :entertainment, :allow_nil => true, :prefix => true
  delegate :category, :cuisine, :feature, :offer, :payment, :to => :meal, :allow_nil => true, :prefix => true

  def category
    [entertainment_category, meal_category].compact.join(', ')
  end

  def cuisine
    meal_cuisine
  end

  def cuisine?
    cuisine.present?
  end

  def feature
    [entertainment_feature, meal_feature].compact.join(', ')
  end

  def feature?
    feature.present?
  end

  def offer
    [entertainment_offer, meal_offer].compact.join(', ')
  end

  def offer?
    offer.present?
  end

  def payment
    [entertainment_payment, meal_payment].compact.join(', ')
  end

  def payment?
    payment.present?
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

