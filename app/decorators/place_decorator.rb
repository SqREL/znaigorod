# encoding: utf-8

class PlaceDecorator
  include Rails.application.routes.url_helpers
  include ActiveAttr::MassAssignment
  include ActionView::Helpers
  include ActiveAttr::QueryAttributes
  attr_accessor :latitude, :longitude, :title
  attribute :organization

  def place
    content_tag(:p, content_tag(:span, link_title, :class => :name) + ", " + content_tag(:span, address_link, :class => :address))
  end

  def link_title
    organization? ? link_to_organization : title
  end

  def address_link
    return link_to(organization.address, '#', :title => 'Показать на карте', :latitude => organization.latitude, :longitude => organization.longitude) if organization?
    link_to("показать на карте", '#', :title => "Показать на карте", :latitude => latitude, :longitude => longitude)
  end

  def link_to_organization
    place_title = organization.title
    link_title = link_to place_title, organization_path(organization), :title => organization.title
  end

end
