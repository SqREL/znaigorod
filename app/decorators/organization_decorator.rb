#encoding: utf-8

class OrganizationDecorator < ApplicationDecorator

  decorates :organization

  def image_for_main_page
    h.link_to image_tag(organization.logotype_url, 100, 75, organization.title), h.organization_path(organization)
  end

end
