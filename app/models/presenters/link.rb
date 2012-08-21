# encoding: utf-8

class Link
   include ActiveAttr::QueryAttributes
   include ActiveAttr::MassAssignment
   attr_accessor :title, :url, :selected, :html_options
   attribute :current
end
