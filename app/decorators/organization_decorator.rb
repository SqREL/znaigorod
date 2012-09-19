#encoding: utf-8

class OrganizationDecorator < ApplicationDecorator
  decorates :organization

  def image_for_main_page
    h.link_to image_tag(organization.logotype_url, 100, 75, organization.title), h.organization_path(organization)
  end

  def title_link(org = parent_organization)
    h.link_to h.hyphenate(organization.title).gilensize.html_safe, h.organization_path(org)
  end

  def address_link(org = parent_organization)
    return "" if organization.address.to_s.blank?
    h.link_to h.hyphenate(organization.address.to_s),
      h.organization_path(org),
      :class => 'show_map_link',
      :latitude => organization.address.latitude,
      :longitude => organization.address.longitude
  end

  def logo_link
    if parent_organization && parent_organization.logotype_url?
      h.link_to image_tag(parent_organization.logotype_url, 180, 180, organization.title.gilensize.gsub(/<\/?\w+.*?>/m, ' ').squish.html_safe), h.organization_path(parent_organization)
    end
  end

  def site_link
    h.link_to site, site, rel: "nofollow", target: "_blank"
  end

  def email_link
    h.mail_to email
  end

  def parent_organization
    organization.organization if organization.respond_to?(:organization)
  end

  def phone
    parent_organization ? parent_organization.phone : organization.phone
  end

  def site
    parent_organization ? parent_organization.site : organization.site
  end

  def email
    parent_organization ? parent_organization.email : organization.email
  end

  def suborganization
    return organization.meal if organization.respond_to?(:meal) && organization.meal
    return organization.entertainment if organization.respond_to?(:entertainment) && organization.entertainment
    return organization.culture if organization.respond_to?(:culture) && organization.culture
  end

  def categories
    suborganization ? suborganization.categories : organization.categories
  end

  def features
    suborganization ? suborganization.features : organization.features
  end

  def offers
    suborganization ? suborganization.offers : organization.offers
  end

  def cuisines
    if suborganization
      suborganization.is_a?(Meal) ? suborganization.cuisines : []
    else
      organization.is_a?(Meal) ? organization.cuisines : []
    end
  end

  def tabs
    [].tap do |links|
      links << h.content_tag(:li, h.link_to("Описание", "#info"))
      links << h.content_tag(:li, h.link_to("Фотографии", "#photogallery", "data-link" => h.organization_photogallery_path), :class => organization.images.blank? ? 'disabled' : nil)
      links << h.content_tag(:li, h.link_to("Афиша", "#affiche", "data-link" => h.organization_affiche_path), :class => affiches.blank? ? 'disabled' : nil)
    end
  end

  def organization_class
    suborganization.try(:class).try(:name).try(:downcase).try(:pluralize)
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

  # NOTE: может быть как-то можно использовать config/initializers/searchers.rb:146
  # но пока фиг знает как ;(
  def raw_similar_organizations
    lat, lon = organization.latitude, organization.longitude
    radius = 3

    search = suborganization.class.search do
      with(:location).in_radius(lat, lon, radius)

      any_of do
        with("#{suborganization.class.name.downcase}_category", categories.map(&:mb_chars).map(&:downcase))
        with("#{suborganization.class.name.downcase}_feature", features.map(&:mb_chars).map(&:downcase)) if features.any?
        with("#{suborganization.class.name.downcase}_offer", offers.map(&:mb_chars).map(&:downcase)) if offers.any?
        with("#{suborganization.class.name.downcase}_cuisine", cuisines.map(&:mb_chars).map(&:downcase)) if suborganization.is_a?(Meal) && cuisines.any?
      end

      without(suborganization)

      order_by_geodist(:location, lat, lon)
      paginate(page: 1, per_page: 5)
    end

    search.results.map(&:organization)
  end

  def similar_organizations
    OrganizationDecorator.decorate raw_similar_organizations
  end
end
