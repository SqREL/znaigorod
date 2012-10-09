# encoding: utf-8

class Schedule < ActiveRecord::Base
  belongs_to :organization

  attr_accessible :day, :from, :to, :holiday

  validates_presence_of :day
  validates_presence_of :from, :to, :unless => :holiday?

  default_scope order('id')

  def self.days_for_select(format = :full)
    format == :full ? format = 'date.standalone_day_names' : format = 'date.common_abbr_day_names'
    array = I18n.t(format).dup
    sunday = array.shift
    array.push(sunday)
    array.each_with_index.map{ |e, i| i+1 == 7 ? [e, 0] : [e, i+1] }
  end

  def human_day
    self.class.days_for_select[day-1].first
  end

  def short_human_day
    self.class.days_for_select(:short)[day-1].first
  end

  def to_s
    "#{human_day} c #{I18n.l(from, :format => "%H:%M")} до #{I18n.l(to, :format => "%H:%M")}"
  end
end

# == Schema Information
#
# Table name: schedules
#
#  id              :integer          not null, primary key
#  day             :integer
#  from            :time
#  to              :time
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  holiday         :boolean
#

