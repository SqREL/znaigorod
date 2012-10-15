class HitDecorator < ApplicationDecorator
  decorates 'sunspot/search/hit'

  AFFICHE_FIELDS = %w[original_title tag]
  ORGANIZATION_FIELDS = %w[category cuisine feature offer payment address]
  ADDITIONAL_FIELDS = AFFICHE_FIELDS + ORGANIZATION_FIELDS

  def image
    return result.poster_url if result.poster_url
    nil
  end

  def image?
    return true unless result.poster_url.blank?
    false
  end

  def  organization?
    result.class.name.underscore.singularize.eql?("organization")
  end

  def image_item
    height = 108
    height = 80 if organization?
    return h.image_tag_for(image, 80, height) if image
    ""
  end

  def kind_links
    kind = ""
    if organization?
      suborganization.categories.each do |category|
        kind << h.content_tag(:li,
                              h.link_to(category, h.organizations_path(organization_class: suborganization.class.name.underscore.gsub(/_decorator/, '').pluralize,
                                                                       category: category.mb_chars.downcase)))
      end
    else
      kind << h.content_tag(:li, h.link_to(self.human_kind, h.affiches_path(kind: self.kind.pluralize, period: :all)))
    end
    kind.html_safe
  end

  def human_kind
    I18n.t("activerecord.models.#{kind}")
  end

  def kind
    result.class.name.downcase
  end

  def raw_suborganization
    return result.meal if result.respond_to?(:meal) && result.meal
    return result.entertainment if result.respond_to?(:entertainment) && result.entertainment
    return result.culture if result.respond_to?(:culture) && result.culture
  end

  def suborganization_decorator_class
    "#{raw_suborganization.class.name.underscore}_decorator".classify.constantize
  end

  def suborganization
    suborganization_decorator_class.decorate raw_suborganization
  end

  def title
    (highlighted(:title) || result.title.truncated(100)).gilensize
  end

  def excerpt
    (highlighted(:description) || result.description.excerpt).gilensize
  end

  def snipped_links
    if organization?
    else
    end
  end

  def closest
    return "" if organization?
    affiche_decorator = AfficheDecorator.new(result)
    h.content_tag :div, affiche_decorator.when_with_price, class: :when_with_price
  end

  def places
    if organization?
      organization_decorator = OrganizationDecorator.new(result)
      h.content_tag(:div, h.content_tag(:span, organization_decorator.address_link, class: :address), class: :places)
    else
      affiche_decorator = AfficheDecorator.new(result)
      result_places = ""
      affiche_decorator.places.each do |place|
        result_places << place.place
      end
      h.content_tag :div, result_places.html_safe, class: :places
    end
  end

  def splitted_fields(field)
    res = ""
    highlighted(field).split(",").each do |piece|
      link = ""
      if organization?
        link = "/#{raw_suborganization.class.name.underscore.pluralize}/all/#{field.pluralize}/#{piece.squish.as_text.mb_chars.downcase}"
      else
        link = "/#{kind.pluralize}/all/#{field.pluralize}/#{piece.squish.as_text}"
      end
      res << h.content_tag(:li, h.link_to(piece.squish.html_safe, link))
    end
    res.html_safe
  end

  def to_partial_path
    'hits/hit'
  end

  def highlighted(field)
    (highlights("#{field}_ru") || highlights(field)).map(&:formatted).map{|phrase| phrase.gsub(/\A[[:punct:][:space:]]+/, '')}.join(' ... ').html_safe.presence
  end

  def truncated(field)
    result.send(field).truncated
  end
end
