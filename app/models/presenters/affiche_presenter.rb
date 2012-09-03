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

  def links
    links = []
    ([Affiche] + Affiche.ordered_descendants).each do |affiche_kind|
      kind = affiche_kind.model_name.downcase.pluralize
      links << Link.new(:title => affiche_kind.model_name.human, :current => kind  == self.kind, :kind => kind, :html_options => {}, :url => affiches_path(kind, period, on))
    end
    links
  end

  def daily_period?
    period == 'daily'
  end
end
