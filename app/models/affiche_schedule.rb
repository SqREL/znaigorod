class AfficheSchedule < ActiveRecord::Base
  belongs_to :affiche

  attr_accessible :affiche, :ends_at, :ends_on, :hall, :holidays, :place, :price_max, :price_min, :starts_at, :starts_on

  validates_presence_of :ends_at, :ends_on, :place, :price_min, :starts_at, :starts_on

  after_save :destroy_showings
  after_save :create_showings
  after_destroy :destroy_showings

  default_value_for :price_min, 0
  default_value_for :price_max, 0

  serialize :holidays, Array
  normalize_attribute :holidays, :with => [:as_array_of_integer]

  private
    def create_showings
      (starts_on..ends_on).each do |date|
        affiche.create_showing attributes_for_showing_on(date) unless holidays.include? date.wday
      end
    end

    def concat_date_and_time(date, time)
      Time.zone.parse "#{date.to_s} #{I18n.l(time, :format => '%H:%M')}"
    end

    def destroy_showings
      affiche.destroy_showings
    end

    def attributes_for_showing_on(date)
      attributes.reject { |k| k.match /(id|created_at|updated_at|starts_on|ends_on)/ }.tap do |hash|
        hash['starts_at'] = concat_date_and_time(date, hash['starts_at'])
        hash['ends_at'] = concat_date_and_time(date, hash['ends_at'])
      end
    end
end

# == Schema Information
#
# Table name: affiche_schedules
#
#  id         :integer         not null, primary key
#  affiche_id :integer
#  starts_on  :date
#  ends_on    :date
#  starts_at  :time
#  ends_at    :time
#  holidays   :string(255)
#  place      :string(255)
#  hall       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

