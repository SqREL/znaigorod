# encoding: utf-8

class Photoreport
  def reports_for_main_page
    searcher.group(:imageable_id_str).groups[0..2].map(&:value).map { |id| Affiche.find(id) }
  end

  def total_reports_count
    searcher.group(:imageable_id_str).total
  end

  def weekly_reports_count
    searcher.weekly.group(:imageable_id_str).total
  end

  def monthly_reports_count
    searcher.monthly.group(:imageable_id_str).total
  end

  private
  def searcher
    HasSearcher.searcher(:photoreport).limit(10_000_000)
  end
end
