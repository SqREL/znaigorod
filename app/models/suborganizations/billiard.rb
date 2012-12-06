class Billiard < Entertainment
  has_many :pool_tables, :dependent => :destroy

  presents_as_checkboxes :category,
    :available_values => -> { HasSearcher.searcher(:entertainment, :entertainment_type => 'Billiard').facet(:entertainment_category).rows.map(&:value).map(&:mb_chars).map(&:capitalize).map(&:to_s) },
    :validates_presence => true,
    :message => I18n.t('activerecord.errors.messages.at_least_one_value_should_be_checked')

  presents_as_checkboxes :feature, :available_values => -> {
    HasSearcher.searcher(:entertainment, :entertainment_type => 'Billiard').facet(:entertainment_feature).rows.map(&:value)
  }

  presents_as_checkboxes :offer, :available_values => -> {
    HasSearcher.searcher(:entertainment, :entertainment_type => 'Billiard').facet(:entertainment_offer).rows.map(&:value)
  }
end

# == Schema Information
#
# Table name: entertainments
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
#  type            :string(255)
#

