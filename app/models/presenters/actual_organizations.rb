# encoding: utf-8

class ActualOrganizations

  def groups
    settings_kinds = []
    today = Time.now.strftime('%A').downcase
    times = Settings["app.actual_organizations.#{today}"]
    times.each do |interval, kinds|
      interval = interval.to_s.split("-").map(&:to_i)
      from, to = interval.first, interval.second
      time_now = Time.now.strftime('%H').to_i
      if time_now >= from && time_now < to
        settings_kinds = kinds
        break
      end
    end
    organization_groups = []
    settings_kinds.each do |kind, options|
      organization_groups << ActualOrganizationGroup.new(:kind => kind, :options => options)
    end
    organization_groups
  end

  class ActualOrganizationGroup
    include ActiveAttr::MassAssignment
    attr_accessor :kind, :options

    def title
      I18n.t("actual_organizations.#{kind}")
    end
  end
end
