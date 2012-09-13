# encoding: utf-8

class OrganizationsController < ApplicationController
  inherit_resources

  has_scope :page, :default => 1

  def index
    @organizations_collection = OrganizationsCollection.new params
    render @organizations_collection.view and return
  end

  protected
  def collection
    @search ||= resource_class.search do
      resource_class.facets.each do |facet|
        if resource_class.or_facets.include?(facet)
          with(resource_class.facet_field(facet), params_facet_values(facet)) if params_facet_values(facet).any?
        else
          params_facet_values(facet).each do |value|
            with(resource_class.facet_field(facet), value)
          end
        end
      end unless resource_class == Organization

      with(:capacity).greater_than(capacity) if capacity?

      resource_class.facets.each do |facet|
        facet(resource_class.facet_field(facet), :zeros => true, :sort => :index)
      end unless resource_class == Organization

      with(:location).in_radius(params[:search][:latitude], params[:search][:longitude], params[:search][:radius]) if params[:search] && params[:search][:latitude] && params[:search][:longitude] && params[:search][:radius]

      paginate(paginate_options)

      adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_fs}*:*" }
    end

    @search.results
  end

  def capacity
    params[:capacity].to_i
  end

  def capacity?
    capacity > 0
  end

  def params_facet_values(facet)
    [*params[:search].try(:[], facet)]
  end

  def params_have_facet?(facet, value)
    params_facet_values(facet).include? value
  end

  def request_parameters
    Marshal.load(Marshal.dump(request.env['rack.request.query_hash'].symbolize_keys))
  end

  def params_with_facet(facet, value)
    request_parameters.tap do | parameters |
      parameters[:facets] ||= {}
    parameters[:facets][facet] ||= []
    parameters[:facets][facet] << value
    parameters[:facets][facet].uniq!
    end
  end

  def params_without_facet(facet, value)
    request_parameters.tap do | parameters |
      parameters[:facets][facet].uniq!
    parameters[:facets][facet].delete(value)
    end
  end

  def capacity
    params[:capacity].to_i
  end

  def capacity?
    capacity > 0
  end

  def params_facet_values(facet)
    [*params[:search].try(:[], facet)]
  end

  def params_have_facet?(facet, value)
    params_facet_values(facet).include? value
  end

  def request_parameters
    Marshal.load(Marshal.dump(request.env['rack.request.query_hash'].symbolize_keys))
  end

  def params_with_facet(facet, value)
    request_parameters.tap do | parameters |
      parameters[:facets] ||= {}
    parameters[:facets][facet] ||= []
    parameters[:facets][facet] << value
    parameters[:facets][facet].uniq!
    end
  end

  def params_without_facet(facet, value)
    request_parameters.tap do | parameters |
      parameters[:facets][facet].uniq!
    parameters[:facets][facet].delete(value)
    end
  end
end
