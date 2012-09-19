#encoding: utf-8

class OrganizationDecorator < ApplicationDecorator
  decorates :organization

  def image_for_main_page
    h.link_to image_tag(organization.logotype_url, 100, 75, organization.title), h.organization_path(organization)
  end

  def logo_link
    if organization.logotype_url?
      h.link_to image_tag(organization.logotype_url, 180, 180, organization.title.gilensize.gsub(/<\/?\w+.*?>/m, ' ').squish.html_safe), h.organization_path(organization)
    end
  end

  def title_link
    h.link_to h.hyphenate(organization.title).gilensize.html_safe, h.organization_path(organization)
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

  def email_link
    h.mail_to email
  end

  def site_link
    h.link_to site, site, rel: "nofollow", target: "_blank"
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

  def tabs
    [].tap do |links|
      links << h.content_tag(:li, h.link_to("Описание", "#info"))
      links << h.content_tag(:li, h.link_to("Фотографии", "#photogallery", "data-link" => h.organization_photogallery_path), :class => organization.images.blank? ? 'disabled' : nil)
      links << h.content_tag(:li, h.link_to("Афиша", "#affiche", "data-link" => h.organization_affiche_path), :class => affiches.blank? ? 'disabled' : nil)
    end
  end

  def suborganization_kind
    raw_suborganization.try(:class).try(:name).try(:downcase).try(:pluralize)
  end

  def affiches
    organization.nearest_affiches.map { |a| AfficheDecorator.new a }
  end

  def html_description
    RedCloth.new(organization.description).to_html.gsub(/&#8220;|&#8221;/, '"').gilensize.html_safe
  end

  def truncated_description
    h.hyphenate(html_description.gsub(/<table>.*<\/table>/m, '').gsub(/<\/?\w+.*?>/m, ' ').squish.truncate(230, :separator => ' ').gilensize).html_safe
  end

  ## NOTE: может быть как-то можно использовать config/initializers/searchers.rb:146
  ## но пока фиг знает как ;(
  def raw_similar_organizations
    lat, lon = organization.latitude, organization.longitude
    radius = 3

    search = suborganization.class.search do
      with(:location).in_radius(lat, lon, radius)

      any_of do
        with("#{raw_suborganization.class.name.downcase}_category", categories.map(&:mb_chars).map(&:downcase))
        with("#{raw_suborganization.class.name.downcase}_feature", features.map(&:mb_chars).map(&:downcase)) if features.any?
        with("#{raw_suborganization.class.name.downcase}_offer", offers.map(&:mb_chars).map(&:downcase)) if offers.any?
        with("#{raw_suborganization.class.name.downcase}_cuisine", cuisines.map(&:mb_chars).map(&:downcase)) if suborganization.is_a?(Meal) && cuisines.any?
      end

      without(raw_suborganization)

      order_by_geodist(:location, lat, lon)
      paginate(page: 1, per_page: 5)
    end

    search.results.map(&:organization)
  end

  def similar_organizations
    OrganizationDecorator.decorate raw_similar_organizations
  end
end
