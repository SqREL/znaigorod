#encoding: utf-8

class OrganizationDecorator < ApplicationDecorator
  decorates :organization

  def image_for_main_page
    unless organization.logotype_url.blank?
      h.link_to image_tag(organization.logotype_url, 100, 75, organization.title), h.organization_path(organization)
    else
      h.link_to h.image_tag("public/stub.jpg", :size => "100x75", :alt => organization.title, :title => organization.title), h.organization_path(organization)
    end
  end

  def logo_link
    if organization.logotype_url?
      h.link_to image_tag(organization.logotype_url, 180, 180, organization.title.text_gilensize), h.organization_path(organization)
    end
  end

  def title_link
    h.link_to organization.title.text_gilensize.hyphenate, h.organization_path(organization)
  end

  def address_link
    return "" if organization.address.to_s.blank?
    h.link_to organization.address.to_s.hyphenate,
      h.organization_path(organization),
      :class => 'show_map_link',
      :latitude => organization.address.latitude,
      :longitude => organization.address.longitude
  end

  def organization_url
    h.organization_url(organization)
  end

  def email_link
    h.mail_to email
  end

  def site_link
    h.link_to site, site, rel: "nofollow", target: "_blank"
  end

  def breadcrumbs
    links = []
    links << h.content_tag(:li, h.link_to("Знай\u00ADГород", h.root_path), :class => "crumb")
    links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
    links << h.content_tag(:li, h.link_to(I18n.t("organization.list_title.#{suborganization_kind.singularize}"), h.organizations_path(:organization_class => suborganization_kind)), :class => "crumb")
    links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
    links << h.content_tag(:li, h.link_to(title, h.organization_path(organization)), :class => "crumb")
    h.content_tag :ul, links.join("\n").html_safe, :class => "breadcrumbs"
  end

  def raw_suborganization
    return organization.meal if organization.respond_to?(:meal) && organization.meal
    return organization.entertainment if organization.respond_to?(:entertainment) && organization.entertainment
    return organization.culture if organization.respond_to?(:culture) && organization.culture
  end

  def suborganization_decorator_class
    "#{raw_suborganization.class.name.underscore}_decorator".classify.constantize
  end

  def suborganization
    suborganization_decorator_class.decorate raw_suborganization
  end

  delegate :categories, :features, :offers, :cuisines, :to => :suborganization

  def has_photogallery?
    organization.images.any?
  end

  def has_tour?
    organization.tour_link?
  end

  def has_affiche?
    actual_affiches_count > 0
  end

  def has_view?
    true
  end

  def navigation
    links = []
    %w(view photogallery tour affiche).each do |method|
      links << Link.new(
                        title: I18n.t("organization.#{method}"),
                        url: h.send(method == 'view' ? "organization_path" : "#{method}_organization_path"),
                        current: h.current_page?(action: method == 'view' ? "show" : method),
                        disabled: !self.send("has_#{method}?"),
                        kind: method
                       )
    end
    current_index = links.index { |link| link.current? }
    links[current_index - 1].html_options[:class] += ' before_current' if current_index > 0
    links[current_index + 1].html_options[:class] += ' after_current' if current_index < links.size - 1
    links[current_index].html_options[:class] += ' current'
    links

  end

  def suborganization_kind
    raw_suborganization.try(:class).try(:name).try(:downcase).try(:pluralize)
  end

  def tags_for_vk
    res = ""
    res << "<meta name='description' content='#{text_description}' />\n"
    res << "<meta property='og:description' content='#{text_description.truncate(350, :separator => ' ')}'/>\n"
    res << "<meta property='og:site_name' content='#{I18n.t('site_title')}' />\n"
    res << "<meta property='og:url' content='#{organization_url}' />\n"
    res << "<meta property='og:title' content='#{title.text_gilensize}' />\n"
    if logotype_url
      image = resized_image_url(logotype_url, 180, 242, false)
      res << "<meta property='og:image' content='#{image}' />\n"
      res << "<meta name='image' content='#{image}' />\n"
      res << "<link rel='image_src' href='#{image}' />\n"
    end
    res.html_safe
  end

  def keywords_content
    keywords = raw_suborganization.categories + raw_suborganization.features + raw_suborganization.offers
    keywords += raw_suborganization.cuisines.map { |cuisine| "#{cuisine} кухня" } if raw_suborganization.is_a?(Meal)

    keywords.map(&:mb_chars).map(&:downcase).join(',')
  end

  def meta_keywords
    h.tag(:meta, name: 'keywords', content: keywords_content)
  end

  def affiches
    [].tap do |array|
      HasSearcher.searcher(:affiche, organization_id: organization.id).actual.order_by_starts_at.affiches.group(:affiche_id_str).groups.map(&:value).map { |id| Affiche.find(id) }.each do |affiche|
        array << AfficheDecorator.new(affiche)
      end
    end
  end

  def actual_affiches_count
    HasSearcher.searcher(:affiche, organization_id: organization.id).actual.order_by_starts_at.affiches.group(:affiche_id_str).total
  end

  def truncated_description
    description.excerpt.hyphenate
  end

  # NOTE: может быть как-то можно использовать config/initializers/searchers.rb
  # но пока фиг знает как ;(
  def raw_similar_organizations
    lat, lon = organization.latitude, organization.longitude
    radius = 3

    search = suborganization.class.search do
      with(:location).in_radius(lat, lon, radius)
      without(raw_suborganization)

      any_of do
        with("#{raw_suborganization.class.name.downcase}_category", categories.map(&:mb_chars).map(&:downcase))
        with("#{raw_suborganization.class.name.downcase}_feature", features.map(&:mb_chars).map(&:downcase)) if features.any?
        with("#{raw_suborganization.class.name.downcase}_offer", offers.map(&:mb_chars).map(&:downcase)) if offers.any?
        with("#{raw_suborganization.class.name.downcase}_cuisine", cuisines.map(&:mb_chars).map(&:downcase)) if suborganization.is_a?(Meal) && cuisines.any?
      end

      order_by_geodist(:location, lat, lon)
      paginate(page: 1, per_page: 5)
    end

    search.results.map(&:organization)
  end

  def similar_organizations
    OrganizationDecorator.decorate raw_similar_organizations
  end
end
