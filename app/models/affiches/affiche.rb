# encoding: utf-8

require 'vkontakte_api'
require 'curb'

class Affiche < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :description, :poster_url, :image_url, :showings_attributes,
                  :tag, :title, :vfs_path, :affiche_schedule_attributes,
                  :images_attributes, :attachments_attributes,
                  :distribution_starts_on, :distribution_ends_on,
                  :original_title, :trailer_code, :vk_aid, :yandex_fotki_url, :constant


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

  after_save :save_images_from_vk, :if => :vk_aid?
  after_save :save_images_from_yandex_fotki, :if => :yandex_fotki_url?

  alias_attribute :tag_ru, :tag
  alias_attribute :title_ru, :title
  alias_attribute :place_ru, :place

  before_save :set_popularity

  searchable do
    text :title,            :boost => 2 * 1.2
    text :title_ru,         :boost => 2,          :more_like_this => true,  :stored => true
    text :original_title,   :boost => 1.5,        :more_like_this => true,  :stored => true
    text :tag,              :boost => 1 * 1.2
    text :tag_ru,           :boost => 1 * 1.2,    :more_like_this => true,  :stored => true
    text :place,            :boost => 1 * 1.2
    text :place_ru,         :boost => 1,          :stored => true
    text :description,      :boost => 0.5 * 1.2                                               do text_description end
    text :description_ru,   :boost => 0.5,        :stored => true                             do text_description end

    boolean :has_images, :using => :has_images?

    float :popularity,        :trie => true

    time :last_showing_time,  :trie => true
  end

  def self.ordered_descendants
    [Movie, Concert, Party, Spectacle, Exhibition, SportsEvent, Other]
  end

  def tags
    tag.split(/,\s+/).map(&:squish)
  end

  def place
    showings.pluck(:place).uniq.join(", ")
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

  def html_description
    @html_description ||= description.as_html
  end

  def text_description
    @text_description ||= html_description.as_text
  end

  private

  def affiche_schedule_attributes_blank?(attributes)
    %w[ends_at ends_on starts_at starts_on].each do |attribute|
      return false unless attributes[attribute].blank?
    end

    true
  end

  def save_images_from_vk
    get_images_from_vk.each do |image_hash|
      self.images.find_or_initialize_by_url_and_thumbnail_url(
        :url => (image_hash['photo']['src_xbig'].present? ? image_hash['photo']['src_xbig'] : image_hash['photo']['src_big']),
        :thumbnail_url => image_hash['photo']['src']
      ).tap do |image|
        image.width  = image_hash['photo']['width']
        image.height = image_hash['photo']['height']
        image.description = image_hash['photo']['text'].present? ? image_hash['photo']['text'] : 'без описания'
        image.save!
      end
    end
  end

  def get_images_from_vk
    id, aid = vk_aid.split('_')

    photos = []

    response = Curl.get(prepare_url_4_vk({ uid: id, aid: aid })).body_str.gsub(/{"error":".+"}/, '')

    if response.empty?
      response = Curl.get(prepare_url_4_vk({ gid: id, aid: aid })).body_str.gsub(/{"error":".+"}/, '')
    end

    photos = JSON.parse(response)['response']
  end

  def prepare_url_4_vk(options)
    params = { api_id: Settings['vk.app_id'], format: 'JSON', method: 'photos.get' }.merge(options).sort

    sig = Digest::MD5.hexdigest(params.map{|k,v| "#{k}=#{v}"}.join + Settings['vk.app_secret'])

    return "http://api.vk.com/api.php?#{params.map{|k,v| "#{k}=#{v}"}.join('&')}&sig=#{sig}"
  end

  def save_images_from_yandex_fotki
    get_images_from_yandex_fotki.each do |image_hash|
      image_hash = image_hash['img']

      self.images.find_or_initialize_by_url_and_thumbnail_url(:url => image_hash['XXL']['href'], :thumbnail_url => image_hash['S']['href']).tap do |image|
        image.description = image_hash['summary'].present? ? image_hash['summary'] : 'без описания'
        image.save!
      end
    end
  end

  def get_images_from_yandex_fotki
    JSON.parse(Curl.get("http://api-fotki.yandex.ru/api/users/#{yandex_fotki_url}/photos/?format=json").body_str)['entries']
  end

  def set_popularity
    self.popularity = 0.3 * yandex_metrika_page_views + vkontakte_likes
  end
end

# == Schema Information
#
# Table name: affiches
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  description               :text
#  original_title            :string(255)
#  poster_url                :string(255)
#  trailer_code              :text
#  type                      :string(255)
#  tag                       :text
#  vfs_path                  :string(255)
#  image_url                 :string(255)
#  distribution_starts_on    :datetime
#  distribution_ends_on      :datetime
#  slug                      :string(255)
#  constant                  :boolean
#  yandex_metrika_page_views :integer
#  vkontakte_likes           :integer
#  vk_aid                    :string(255)
#  yandex_fotki_url          :string(255)
#  popularity                :float
#

