# encoding: utf-8

class Link
  include ActiveAttr::QueryAttributes
  include ActiveAttr::MassAssignment
  attr_accessor :title, :kind, :selected, :html_options, :url
  attribute :current
end
