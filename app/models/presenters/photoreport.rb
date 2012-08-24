# encoding: utf-8

class Photoreport
  def self.reports_for_main_page
    searcher.groups[0..2].map(&:value).map { |id| Affiche.find(id) }
  end

  def self.total_reports_count
    searcher.total
  end

  private
  def self.searcher
    HasSearcher.searcher(:photoreport).limit(10_000_000).group(:imageable_id_str)
  end
end
