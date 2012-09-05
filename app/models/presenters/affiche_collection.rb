# encoding: utf-8

class AfficheCollection
  include Rails.application.routes.url_helpers
  include ActiveAttr::MassAssignment
  attr_accessor :kind, :period, :on, :tags, :page


  def initialize(options)
    super(options)
    begin
      self.on = Date.parse(self.on)
    rescue
      self.on = Date.today
    end if self.daily_period?
    self.tags = self.tags.split("/") if self.tags
    self.tags ||= []
  end

  def kind_links
    links = []
    ([Affiche] + Affiche.ordered_descendants).each do |affiche_kind|
      kind = affiche_kind.model_name.downcase.pluralize
      links << Link.new(:title => affiche_kind.model_name.human, :current => kind  == self.kind, :kind => kind, :html_options => {}, :url => affiches_path(kind, period, on))
    end
    current_index = links.index { |link| link.current? }
    links[current_index - 1].html_options[:class] = :before_current if current_index > 0
    links[current_index + 1].html_options[:class] = :after_current if current_index < links.size - 1
    links[current_index].html_options[:class] = :current
    links
  end

  def period_links
    links = []
    %w(today weekly weekend daily all).each do |affiche_period|
      link_title = human_period(affiche_period)
      link_title += "&nbsp;(#{counter.send(affiche_period)})" unless affiche_period == 'daily'
      html_options = affiche_period == 'daily' ? { :class => 'daily ' } : { :class => '' }
      links << Link.new(:title => link_title.html_safe,
                        :current => affiche_period == period,
                        :html_options => html_options,
                        :url => affiches_path(kind, affiche_period))
    end
    current_index = links.index { |link| link.current? }
    links[current_index - 1].html_options[:class] += 'before_current' if current_index > 0
    links[current_index + 1].html_options[:class] += 'after_current' if current_index < links.size - 1
    links[current_index].html_options[:class] += 'current'
    links
  end

  def counter
    Counter.new(:kind => kind.singularize)
  end

  def facets
    searcher_params = search_params
    searcher_params.delete(:tags)
    searcher(searcher_params).faceted.facet(:tags).rows.map(&:value)
  end

  def tag_links
    [].tap do |array|
      facets.each do |tag|
        html_options = tags.include?(tag) ? { :class => :selected } : {}
        array << Link.new(:title => tag, :current => tags.include?(tag), :html_options => html_options, :url => url_for_tag(tag))
      end
    end
  end

  def url_for_tag(tag)
    affiches_path(kind, period, on, tag_params(tag))
  end

  def daily_period?
    period == 'daily'
  end

  def human_period(affiche_period = nil)
    affiche_period ||= period
    return I18n.l(on, :format => '%e %B') if affiche_period == 'daily' && on
    return I18n.t("affiche_periods.all.#{kind}") if affiche_period == 'all'
    I18n.t("affiche_periods.#{affiche_period}")
  end

  def human_kind
    I18n.t("activerecord.models.#{kind.singularize}")
  end

  def affiches
    [].tap do |array|
      paginated_affiches.map(&:value).map { |id| Affiche.find(id) }.each do |affiche|
        array << AfficheItem.new(:affiche => affiche, :showings => searcher(search_params(affiche.id)).results)
      end
    end
  end

  def paginated_affiches
    searcher(search_params).paginate(:page => page, :per_page => 5).affiches.group(:affiche_id_str).groups
  end

  def searcher_scopes
    [].tap do |scopes|
      case period
      when 'today'
        scopes << 'today'
      when 'daily'
        if on == Date.today
          scopes << 'today'
        else
          scopes << 'actual'
        end
      when 'weekend'
        scopes << 'weekend'
        scopes << 'actual'
      when 'weekly'
        scopes << 'weekly'
        scopes << 'actual'
      when 'all'
        scopes << 'actual'
      end
    end
  end

  private

  def searcher(searcher_params)
    HasSearcher.searcher(:affiche, searcher_params).tap do |searcher|
      searcher_scopes.each do |scope|
        searcher.send(scope)
      end
    end
  end

  def search_params(affiche_id = nil)
    search_params = {}
    search_params[:affiche_category] = kind.singularize unless kind == 'affiches'
    search_params[:starts_on] = on if period == 'daily'
    search_params[:tags] = tags if tags.any?
    search_params[:affiche_id] = affiche_id if affiche_id
    search_params
  end

  def tag_params(tag)
    to_params_arr = tags.dup
    if to_params_arr.include?(tag)
      to_params_arr = to_params_arr - [tag]
    else
      to_params_arr << tag
    end
    to_params_arr.any? ? to_params_arr.join("/") : nil
  end

end
