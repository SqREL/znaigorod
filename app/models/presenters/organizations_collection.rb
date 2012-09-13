class OrganizationsCollection
  include ActiveAttr::MassAssignment
  include Rails.application.routes.url_helpers

  attr_accessor :organization_class, :category, :query

  def initialize(params)
    super(params)
    @organization_class ||= 'organizations'
    @organization_class = @organization_class.singularize
    @category ||= 'all'
    @category = @category.mb_chars.downcase
  end

  def self.kinds
    [Meal, Entertainment, Culture]
  end

  self.kinds.map(&:name).map(&:downcase).each do |klass|
    define_method "#{klass}_searcher" do |params = {}|
      HasSearcher.searcher(klass.to_sym, params)
    end

    define_method "#{klass}_categories_links" do
      self.send("#{klass}_categories").map do |row|
        Link.new(title: "#{row.value.mb_chars.capitalize} (#{row.count})", url: organizations_path(organization_class: klass.pluralize, category: row.value.mb_chars.downcase))
      end
    end

    define_method "#{klass}_categories" do
      self.send("#{klass}_searcher").categories.facet("#{klass}_category").rows
    end
  end

  def kind_links
    {}.tap do |links|
      self.class.kinds.map(&:name).map(&:downcase).each do |klass|
        links[Link.new(title: I18n.t("organization.kind.#{klass}"), url: organizations_path(organization_class: klass.pluralize))] = self.send("#{klass}_categories_links")
      end
    end
  end

  def class_categories_links
    [Link.new(title: I18n.t("organization.all.#{organization_class}"), url: organizations_path(organization_class: organization_class.pluralize), current: category == 'all')].tap do |links|
      self.send("#{organization_class}_categories").each do |row|
        link_kind = row.value.mb_chars.downcase
        links << Link.new(title: "#{row.value.mb_chars.capitalize} (#{row.count})", url: organizations_path(organization_class: organization_class.pluralize, category: link_kind), current: category == link_kind)
      end
      current_index = links.index { |link| link.current? }
      links[current_index - 1].html_options[:class] = :before_current if current_index > 0
      links[current_index + 1].html_options[:class] = :after_current if current_index < links.size - 1
      links[current_index].html_options[:class] = :current
    end
  end

  def categories
    parameters['categories'] || []
  end

  def features
    parameters['features'] || []
  end

  def offers
    parameters['offers'] || []
  end

  def cuisines
    parameters['cuisines'] || []
  end

  def parameters
    return {} if query.blank?
    {}.tap do |parameters|
      filter = ""
      query.split("/").each do |param|
        if filter_groups.include?(param.singularize)
          filter = param
          parameters[filter] = []
          next
        end
        parameters[filter] << param if parameters[filter]
      end
    end
  end

  def title
    I18n.t("organization.list_title.#{organization_class}")
  end

  def subtitle
    return "" if category == 'all'
    category
  end

  def filter_groups
    groups = []
    groups << 'category' if category == 'all'
    groups << 'cuisine' if organization_class == 'meal'
    groups += ['offer', 'feature']
  end

  def filters
    {}.tap do |hash|
      filter_groups.each do |group|
        hash[group] = self.send("#{group}_filters")
      end
    end
  end

  def category_search_params
    return nil if category == 'all'
    { "#{organization_class}_category" => [category] }
  end

  def filter_link_url(params)
    filter_params = {}
    filter_groups.each do |filter|
      existed_filter_params = self.send(filter.pluralize) || []
      tag = params[filter.to_sym]
      if existed_filter_params.include?(tag)
        existed_filter_params = existed_filter_params - [tag]
      else
        existed_filter_params << tag
      end
      filter_params[filter] = existed_filter_params
    end
    query = []
    filter_params.each do |key, values|
      next if values == [nil]
      query += [key.pluralize] + values
    end
    organizations_path(organization_class: organization_class.pluralize, category: category, query: query.join("/"))
  end

  def category_filters
    self.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_category").rows.map(&:value).
      map { |value| Link.new title: value, url: filter_link_url(category: value), html_options: { :class => (categories.include?(value) ? 'selected' : nil) } }
  end

  def cuisine_filters
    self.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_cuisine").rows.map(&:value).
      map { |value| Link.new title: value, url: filter_link_url(cuisine: value), html_options: { :class => (cuisines.include?(value) ? 'selected' : nil) } }
  end

  def offer_filters
    self.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_offer").rows.map(&:value).
      map { |value| Link.new title: value, url: filter_link_url(offer: value), html_options: { :class => (offers.include?(value) ? 'selected' : nil) } }
  end

  def feature_filters
    self.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_feature").rows.map(&:value).
      map { |value| Link.new title: value, url: filter_link_url(feature: value), html_options: { :class => (features.include?(value) ? 'selected' : nil) } }
  end

  def view
    return 'catalog' if organization_class == 'organization'
    'index'
  end

end
