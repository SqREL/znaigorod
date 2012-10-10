class HitDecorator < ApplicationDecorator
  decorates 'sunspot/search/hit'

  AFFICHE_FIELDS = %w[original_title tag]
  ORGANIZATION_FIELDS = %w[category cuisine feature offer payment address]
  ADDITIONAL_FIELDS = AFFICHE_FIELDS + ORGANIZATION_FIELDS

  def title
    highlighted(:title_ru) || truncated(:title)
  end

  def excerpt
    highlighted(:description_ru) || truncated(:description_as_plain_text)
  end

  def to_partial_path
    'hits/hit'
  end

  def highlighted(field)
    highlights(field).map(&:formatted).map{|phrase| phrase.gsub(/\A[[:punct:][:space:]]+/, '')}.join(' ... ').html_safe.presence
  end

  def truncated(field)
    h.truncate(result.send(field), :length => 256, :separator => ' ')
  end
end
