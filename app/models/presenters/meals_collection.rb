# encoding: utf-8

class MealsCollection < OrganizationsCollection
  include ActiveAttr::MassAssignment

  attr_accessor :kind, :query

  def initialize(params)
    super(params)
  end

  def categories
    parameters['categories']
  end

  def features
    parameters['features']
  end

  def offers
    parameters['offers']
  end

  def cuisines
    parameters['cuisines']
  end

  def parameters
    return {} if query.blank?
    Hash[Hash[query.scan(/(categories|cuisines|features|offers)?(?:\/)?((?:\w+(?:\/)?){2})(?!categories|cuisines|features|offers)?/)].map { |k,v| [k, v.split('/')]}]
  end

  def link_categories
    [Link.new(title: "Все заведения питания", url: meals_path(kind: :all), current: kind == 'all')].tap do |links|
      meal_searcher.categories.facet("meal_category").rows.each do |row|
        link_kind = I18n.transliterate(row.value).downcase
        links << Link.new(title: "#{row.value} (#{row.count})", url: meals_path(kind: link_kind), current: kind == link_kind)
      end
      current_index = links.index { |link| link.current? }
      links[current_index - 1].html_options[:class] = :before_current if current_index > 0
      links[current_index + 1].html_options[:class] = :after_current if current_index < links.size - 1
      links[current_index].html_options[:class] = :current
    end
  end
end
