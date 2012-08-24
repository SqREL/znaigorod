# encoding: utf-8

class Photoreport
  def self.reports_for_main_page
    searcher.groups[0..2].map(&:value).map { |id| Affiche.find(id) }
  end

  def self.total_reports_count
    searcher.group(:imageable_id_str).total
  end

  def self.weekly_reports_count
    searcher.weekly.group(:imageable_id_str).total
  end

  def  self.monthly_reports_count
    searcher.monthly.group(:imageable_id_str).total
  end

  private
  def self.searcher
    HasSearcher.searcher(:photoreport).limit(10_000_000)
  end
end
