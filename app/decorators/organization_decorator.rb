#encoding: utf-8

class OrganizationDecorator < ApplicationDecorator
  decorates :organization

  def image_for_main_page
    h.link_to image_tag(organization.logotype_url, 100, 75, organization.title), h.organization_path(organization)
  end

  def title_link
    h.link_to organization.title, '#'
  end

  def address_link
    h.link_to organization.address,
      '#',
      :class => 'show_map_link',
      :latitude => organization.address.latitude,
      :longitude => organization.address.longitude
  end

  def logo_link
    h.link_to image_tag(parent_organization.logotype_url, 300, 300, organization.title), '#'
  end

  def category_links
    organization.categories.map { |category| Link.new title: category, url: '#' }
  end

  def feature_links
    organization.features.map { |feature| Link.new title: feature, url: '#' }
  end

  def offer_links
    organization.offers.map { |offer| Link.new title: offer, url: '#' }
  end

  def site_link
    h.link_to site, site
  end

  def email_link
    h.mail_to email
  end

  def parent_organization
    organization.organization
  end

  delegate :phone, :site, :email, :to => :parent_organization
end
