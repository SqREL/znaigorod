class Affiche < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :description, :poster_url, :image_url, :showings_attributes,
                  :tag, :title, :vfs_path, :affiche_schedule_attributes,
                  :images_attributes, :attachments_attributes,
                  :distribution_starts_on, :distribution_ends_on,
                  :original_title, :trailer_code


  has_many :images,      :as => :imageable, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :showings, :dependent => :destroy, :order => :starts_at

  has_one :affiche_schedule, :dependent => :destroy

  validates_presence_of :description, :poster_url, :title

  accepts_nested_attributes_for :affiche_schedule, :allow_destroy => true, :reject_if => :affiche_schedule_attributes_blank?
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :showings, :allow_destroy => true

  default_scope order('affiches.id DESC')
  default_value_for :yandex_metrika_page_views, 0
  default_value_for :vkontakte_likes, 0

  scope :latest,           ->(count) { limit(count) }
  scope :with_images,      -> { where('image_url IS NOT NULL') }
  scope :with_showings,    -> { includes(:showings).where('showings.starts_at > :date OR showings.ends_at > :date', { :date => Date.today }) }

  alias_attribute :to_s, :title

  friendly_id :title, use: :slugged

  normalize_attribute :image_url

  searchable do
    boolean :has_images, :using => :has_images?
    integer :showing_ids, :multiple => true
    string(:kind) { 'affiche' }
    text :title,            :boost => 2,    :more_like_this => true
    text :original_title,   :boost => 1.5,  :more_like_this => true
    text :tag,              :boost => 1,    :more_like_this => true
    text :description,      :boost => 0.5
    text(:kind) { self.class.model_name.human }
    time :first_showing_time, :trie => true
    time :last_showing_time
  end

  def self.ordered_descendants
    [Movie, Concert, Party, Spectacle, Exhibition, SportsEvent, Other]
  end

  def search_showing_ids(search_params)
    search_params ||= {}
    params = search_params.reverse_merge :starts_on_greater_than => Date.today,
                                         :affiche_id => self.id
    HasSearcher.searcher(:showing, params).result_ids
  end

  def showings_grouped_by_day(search_params = nil)
    showing_ids = search_showing_ids(search_params)

    Hash[showings.where(:id => showing_ids).group_by(&:starts_on).map.first(9)]
  end

  def showings_grouped_by_organization_and_day(organization, search_params = nil)
    showing_ids = search_showing_ids(search_params)
    Hash[showings.where(:id => showing_ids, :organization_id => organization.id).group_by(&:starts_on).map.first(9)]
  end

  def tags
    tag.split(/,\s+/).map(&:squish)
  end

  def place
    showings.map(&:place).uniq.join(", ")
  end

  def first_showing
    showings.first
  end

  def first_showing_time
    first_showing.try(:starts_at)
  end

  def last_showing
    showings.last
  end

  def last_showing_time
    last_showing.try(:ends_at) || last_showing.try(:starts_at)
  end

  def create_showing(attributes)
    showings.create attributes
  end

  def destroy_showings
    showings.destroy_all
  end

  def has_images?
    images.any?
  end

  def popularity
    0.3 * yandex_metrika_page_views.to_i + vkontakte_likes.to_i
  end

  private
    def affiche_schedule_attributes_blank?(attributes)
      %w[ends_at ends_on starts_at starts_on].each do |attribute|
        return false unless attributes[attribute].blank?
      end

      true
    end
end

# == Schema Information
#
# Table name: affiches
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  description    :text
#  original_title :string(255)
#  poster_url     :string(255)
#  trailer_code   :text
#  type           :string(255)
#  tag            :text
#  vfs_path       :string(255)
#  image_url      :string(255)
#

