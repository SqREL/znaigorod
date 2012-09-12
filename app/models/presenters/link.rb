# encoding: utf-8

class Link
  include ActiveAttr::QueryAttributes
  include ActiveAttr::MassAssignment
  include ActionView::Helpers::UrlHelper
  attr_accessor :title, :kind, :selected, :html_options, :url
  attribute :current

  def to_s
    link_to title, url, html_options
  end
end
