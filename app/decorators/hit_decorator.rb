class HitDecorator < ApplicationDecorator
  decorates 'sunspot/search/hit'

  def title
    highlighted(:title_ru) || truncated(:title)
  end

  def excerpt
    highlighted(:description_ru) || truncated(:description_as_plain_text)
  end

  def additional_fields
    %w[original_title]
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
