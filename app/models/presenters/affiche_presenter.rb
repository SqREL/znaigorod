# encoding: utf-8

class AffichePresenter
  include Rails.application.routes.url_helpers
  include ActiveAttr::MassAssignment
  attr_accessor :kind, :period, :on


  def initialize(options)
    super(options)
    begin
      self.on = Date.parse(self.on)
    rescue
      self.on = Date.today
    end if self.daily_period?
  end

  def kind_links
    links = []
    ([Affiche] + Affiche.ordered_descendants).each do |affiche_kind|
      kind = affiche_kind.model_name.downcase.pluralize
      links << Link.new(:title => affiche_kind.model_name.human, :current => kind  == self.kind, :kind => kind, :html_options => {}, :url => affiches_path(kind, period, on))
    end
    links
  end

  def period_links
    [].tap do |array|
      %w(today weekly weekend daily all).each do |affiche_period|
        link_title = human_period(affiche_period)
        link_title += " (#{counter.send(affiche_period)})" unless affiche_period == 'daily'
        array << Link.new(:title => link_title,
                          :current => affiche_period == period,
                          :html_options => {},
                          :url => affiches_path(kind, affiche_period))
      end
    end
  end

  def counter
    Counter.new(:kind => kind.singularize)
  end

  def daily_period?
    period == 'daily'
  end

  def human_period(affiche_period = nil)
    affiche_period ||= period
    return "На #{I18n.l(on, :format => '%e %B')}" if affiche_period == 'daily' && on
    return I18n.t("affiche_periods.all.#{kind}") if affiche_period == 'all'
    I18n.t("affiche_periods.#{affiche_period}")
  end

  def human_kind
    I18n.t("activerecord.models.#{kind.singularize}")
  end

end
