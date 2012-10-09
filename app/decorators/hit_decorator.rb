class HitDecorator < ApplicationDecorator
  decorates 'sunspot/search/hit'

  def title
    h.safe_join [highlight(:title_ru), "(".html_safe + highlight(:original_title) + ")".html_safe], " "
  end

  def excerpt
    highlight(:description_ru)
  end

  def to_partial_path
    'hits/hit'
  end


  private
    def highlight(field)
      h.highlight stored(field).first, phrases(field) rescue nil
    end

    def phrases(field)
      highlights(field).map do |highlight|
        highlight.instance_eval { @highlight }.scan(/@@@hl@@@([^@]+)@@@endhl@@@/)
      end.flatten
    end
end
