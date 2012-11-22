class Service < ActiveRecord::Base
  attr_accessible :age, :title, :feature, :category, :description

  belongs_to :context, :polymorphic => true

  validates_presence_of :category

  alias_attribute :to_s, :title

  delegate :index, :to => :context, :prefix => true
  after_save :context_index

  normalize_attributes :feature, :with => :blank
end

# == Schema Information
#
# Table name: services
#
#  id           :integer          not null, primary key
#  title        :text
#  feature      :text
#  age          :text
#  context_type :string(255)
#  context_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  category     :text
#

