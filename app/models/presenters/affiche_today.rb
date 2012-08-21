class AfficheToday
  attr_accessor :kind

  def initialize(kind = nil)
    self.kind = kind || default_kind
  end

  def default_kind
    settings_kinds = []
    today = Time.now.strftime('%A').downcase
    times = Settings["app.affiche_today.#{today}"]
    times.each do |interval, kinds|
      interval = interval.to_s.split("-").map(&:to_i)
      from, to = interval.first, interval.second
      time_now = Time.now.strftime('%H').to_i
      if time_now >= from && time_now < to
        settings_kinds = kinds
        break
      end
    end
    prng = Random.new(1234)
    settings_kinds[prng.rand(0..settings_kinds.size - 1)]
  end

  def links
    links = []
    Affiche.ordered_descendants.each do |affiche_kind|
      links << Link.new(:title => affiche_kind.model_name.human, :url => '#', :current => affiche_kind.to_s == self.kind)
    end
    links
  end

  def counters
    counters = {}
    Affiche.ordered_descendants.each do |affiche_kind|
      counters[affiche_kind] = Counter.new(:kind => affiche_kind)
    end
    counters
  end
end
