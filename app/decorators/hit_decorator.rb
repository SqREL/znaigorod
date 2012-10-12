class HitDecorator < ApplicationDecorator
  decorates 'sunspot/search/hit'

  AFFICHE_FIELDS = %w[original_title tag]
  ORGANIZATION_FIELDS = %w[category cuisine feature offer payment address]
  ADDITIONAL_FIELDS = AFFICHE_FIELDS + ORGANIZATION_FIELDS

  def title
    highlighted(:title) || result.title.truncated(100)
  end

  def excerpt
    highlighted(:description) || result.description.excerpt
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
