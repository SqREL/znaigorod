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
      h.link_to image_tag(organization.logotype_url, 180, 180, organization.title.gilensize.gsub(/<\/?\w+.*?>/m, ' ').squish.html_safe), h.organization_path(organization)
    end
  end

  def title_link
    h.link_to h.hyphenate(organization.title).gilensize.html_safe, h.organization_path(organization)
  end

  def address_link
    return "" if organization.address.to_s.blank?
    h.link_to h.hyphenate(organization.address.to_s),
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

  def navigation
    [].tap do |links|
      klass = []
      klass << "current" if h.current_page?(h.organization_path)
      klass << "before_current" if h.current_page?(h.organization_photogallery_path)
      links << h.content_tag(:li, h.link_to("Описание", h.organization_path),
                             :class => klass.any? ? klass.join(" ") : nil)
      klass = []
      klass << "disabled" if organization.images.blank?
      klass << "current" if h.current_page?(h.organization_photogallery_path)
      klass << "before_current" if h.current_page?(h.organization_affiche_path)
      unless organization.images.blank?
        links << h.content_tag(:li, h.link_to("Фотографии", h.organization_photogallery_path),
                               :class => klass.any? ? klass.join(" ") : nil)
      else
        links << h.content_tag(:li, h.content_tag(:span, "Фотографии", :title => "Недоступно"),
                               :class => klass.any? ? klass.join(" ") : nil)
      end
      klass = []
      klass << "disabled" if affiches.blank?
      klass << "current" if h.current_page?(h.organization_affiche_path)
      klass << "before_current" if h.current_page?(h.organization_tour_path)
      unless affiches.blank?
      links << h.content_tag(:li, h.link_to("Афиша", h.organization_affiche_path),
                             :class => klass.any? ? klass.join(" ") : nil)
      else
        links << h.content_tag(:li, h.content_tag(:span, "Афиша", :title => "Недоступно"),
                               :class => klass.any? ? klass.join(" ") : nil)
      end
      klass = []
      klass << "disabled" if organization.tour_link.blank?
      klass << "current" if h.current_page?(h.organization_tour_path)
      unless organization.tour_link.blank?
        links << h.content_tag(:li, h.link_to("3D-тур", h.organization_tour_path),
                               :class => klass.any? ? klass.join(" ") : nil)
      else
        links << h.content_tag(:li, h.content_tag(:span, "3D-тур", :title => "Недоступно"),
                               :class => klass.any? ? klass.join(" ") : nil)
      end
    end
  end

  def suborganization_kind
    raw_suborganization.try(:class).try(:name).try(:downcase).try(:pluralize)
  end

  def tags_for_vk
    desc = html_description.gsub(/<table>.*<\/table>/m, '').gsub(/<\/?\w+.*?>/m, ' ').squish.html_safe
    res = ""
    res << "<meta name='description' content='#{desc}' />\n"
    res << "<meta property='og:description' content='#{desc.truncate(350, :separator => ' ').html_safe}'/>\n"
    res << "<meta property='og:site_name' content='#{I18n.t('site_title')}' />\n"
    res << "<meta property='og:url' content='#{organization_url}' />\n"
    res << "<meta property='og:title' content='#{page_title(title)}' />\n"
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

  def truncated_description
    html_description.excerpt.hyphenate
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
