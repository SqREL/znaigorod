class SuborganizationDecorator < ApplicationDecorator
  def decorated_organization
    OrganizationDecorator.decorate organization
  end

  delegate :logo_link, :title_link, :address_link, :html_description,
    :truncated_description, :site_link, :email_link,
    :to => :decorated_organization
end
