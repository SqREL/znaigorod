class AfficheItem
  include ActiveAttr::MassAssignment
  attr_accessor :affiche, :showings

  delegate :list_poster, :link_with_full_title, :tags, :to => :affiche_decorator

  def human_when
    return affiche_decorator.human_distribution if affiche.distribution_starts_on?

    return showing_decorators.first.human_when
  end

  def affiche_decorator
    @affiche_decorator ||= AfficheDecorator.decorate affiche
  end

  def showing_decorators
    @showing_decorators ||= ShowingDecorator.decorate(showings)
  end

  def affiche_distribution?
    affiche.distribution_starts_on?
  end
end
