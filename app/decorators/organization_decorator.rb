#encoding: utf-8

class OrganizationDecorator < ApplicationDecorator
  decorates :organization

  def image_for_main_page
    h.link_to image_tag(organization.logotype_url, 100, 75, organization.title), h.organization_path(organization)
  end

  def title_link
    h.link_to organization.title, h.organization_path(parent_organization)
  end

  def address_link
    h.link_to organization.address,
      h.organization_path(parent_organization),
      :class => 'show_map_link',
      :latitude => organization.address.latitude,
      :longitude => organization.address.longitude
  end

  def logo_link
    if parent_organization && parent_organization.logotype_url?
      h.link_to image_tag(parent_organization.logotype_url, 300, 300, organization.title), h.organization_path(parent_organization)
    end
  end

  def site_link
    h.link_to site, site
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

  def organization_class
    suborganization.try(:class).try(:name).try(:downcase).try(:pluralize)
  end

  def affiches
    organization.nearest_affiches.map { |a| AfficheDecorator.new a }
  end
end
