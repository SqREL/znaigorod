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

  def self.facet_field(facet)
    "#{model_name.underscore}_#{facet}"
  end

  def self.add_sunspot_configuration
    searchable do |s|
      s.integer(:capacity, :multiple => true) { halls.pluck(:seating_capacity) }
      s.string(:kind) { 'organization' }
      s.text :address
      s.text :description, :boost => 0.5
      s.text :email, :boost => 0.5
      s.text :site, :boost => 0.5
      s.text :title, :boost => 2
      s.text(:kind) { self.class.model_name.human }
      s.text :term

      facets.each do |facet|
        s.text facet
        s.string(facet_field(facet), :multiple => true) { self.send(facet).to_s.split(',').map(&:squish) }
      end

      s.boost 45
    end
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

  def categories
    res = []
    res << entertainment.category if entertainment
    res << meal.category if meal
    res.join(', ')
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

