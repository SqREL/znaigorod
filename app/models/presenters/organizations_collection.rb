class OrganizationsCollection
  include ActiveAttr::MassAssignment
  include Rails.application.routes.url_helpers

  attr_accessor :kind, :query

  def self.kinds
    [Meal, Entertainment, Culture]
  end

  self.kinds.map(&:name).map(&:downcase).each do |klass|
    define_method "#{klass}_searcher" do
      HasSearcher.searcher(klass.to_sym)
    end

    define_method "#{klass}_categories" do
      self.send("#{klass}_searcher").categories.facet("#{klass}_category").rows.map(&:value).map do |category|
        Link.new(title: category, url: send("#{klass.pluralize}_path", kind: I18n.transliterate(category)).downcase)
      end
    end
  end

  def kind_links
    {}.tap do |links|
      self.class.kinds.map(&:name).map(&:downcase).each do |klass|
        links[Link.new(title: I18n.t("organization.kind.#{klass}"), url: send("#{klass.pluralize}_path", kind: :all))] = self.send("#{klass}_categories")
      end
    end
  end
end
