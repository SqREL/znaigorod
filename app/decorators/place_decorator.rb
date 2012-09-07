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

  def link_title(gsub = nil)
    organization? ? link_to_organization(gsub) : title.gilensize.html_safe
  end

  def link_short_title
    link_title('with_gsub')
  end

  def address_link
    return link_to(organization.address, '#', :title => 'Показать на карте',
                   :latitude => organization.latitude,
                   :longitude => organization.longitude,
                   :class => 'show_map_link') if organization?
    return link_to('показать на карте', '#', :title => "Показать на карте",
                   :latitude => latitude,
                   :longitude => longitude,
                   :class => 'show_map_link')
  end

  def link_to_organization(gsub = nil)
    place_title = organization.title
    place_title = place_title.gsub(/,.*/, '') if gsub
    link_title = link_to place_title.gilensize.html_safe, organization_path(organization), :title => organization.title
  end

end
