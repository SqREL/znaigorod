# encoding: utf-8

module ApplicationHelper

  def facet_status(facet, row)
    result = params_have_facet?(facet, row.value) ? 'selected' : 'unselected'
    result << ' inactive' if row.count.zero?

    result
  end

  def image_tag_for(url, width, height, crop = true)
    image_tag resized_image_url(url, width, height, crop)
  end

  def image_image_tag_for(affiche, width, height, options={})
    image_tag resized_image_url(affiche.image_url, width, height, true), :alt => affiche.title, :title => affiche.title
  end

  def price_for(showing)
    return 'бесплатно' if showing.price_min.zero? && showing.price_max.zero?
    return number_to_currency(showing.price_min, :precision => 0) if showing.price_max.zero?

    "#{showing.price_min} &mdash; #{number_to_currency(showing.price_max, :precision => 0)}".html_safe
  end

  def path_for(item)
    case item.class.superclass.name
    when 'Affiche'
      affiche_path(item)
    when 'Organization'
      organization_path(item)
    end
  end

  def search_class(resource_class)
    return resource_class if [Affiche, Organization].include?(resource_class)
    return Affiche        if Affiche.descendants.include?(resource_class)
    return Organization   if Organization.descendants.include?(resource_class)
  end

  def transliterate(string)
    I18n.transliterate(string).downcase.gsub(/[^[:alnum:]]+/,'_')
  end

  def interval_for(showing)
    since_date, since_time = l(showing.starts_at.to_datetime, :format => '%d.%B.%Y %H:%M').split(' ')
    until_date, until_time = l(showing.ends_at.to_datetime, :format => '%d.%B.%Y %H:%M').split(' ') if showing.ends_at

    since_date.gsub!('.', ' ')
    until_date.gsub!('.', ' ') if showing.ends_at

    since_arr = []
    until_arr = []

    since_arr << content_tag(:span, since_date, :class => 'nobr')
    until_arr << content_tag(:span, until_date, :class => 'nobr') if since_date != until_date && !until_date.nil?

    if since_time != '00:00'
      since_arr << ", #{since_time}"
      if until_time != '00:00' && until_time != '23:59' && !until_time.nil?
        if since_time != until_time
          if until_arr.empty?
            until_arr << until_time
          else
            until_arr << ", #{until_time}"
          end
        else
          unless until_arr.empty?
            until_arr << ", #{until_time}"
          end
        end
      end
    else
      if until_time != '00:00' && until_time != '23:59' && !until_time.nil?
        unless until_arr.empty?
          until_arr << ", #{until_time}"
        end
      end
    end

    res = since_arr.join

    unless until_arr.empty?
      res += ' &ndash; '
      res += until_arr.join
    end

    res.html_safe
  end

  def is_active_range?(range_name)
    case range_name
      when 'amount'
        if params['search']['price_greater_than'] == '0' && params['search']['price_less_than'] == '>1500'
          false
        else
          true
        end
      when 'time'
        if params['search']['starts_at_hour_greater_than'] == '0' && params['search']['starts_at_hour_less_than'] == '23'
          false
        else
          true
        end
    end if params['search']
  end

  def is_active_filter?(filter_name)
    return params.has_key?('search') && params['search'][filter_name].try(:any?) ? true : false
  end

  def is_active_variant?(filter, variant)
    if is_active_filter?(filter) == true
      params['search'][filter].include?(variant) ? 'active' : ''
    else
      false
    end
  end

  def form_url_for_resource
    if resource.class.superclass == Affiche ||resource_class == Organization
      return [:manage, resource]
    elsif resource_class == Meal || resource_class == Entertainment
      return send("manage_organization_#{resource_class.model_name.underscore}_path", parent)
    elsif parent.class.superclass == Affiche
      return send("manage_#{parent.class.superclass.model_name.underscore}_#{resource_class.model_name.underscore.pluralize}_path", parent)
    elsif parent.class == Organization
      return send("manage_organization_#{resource_class.model_name.underscore.pluralize}_path", parent)
    end
  end

  private

    def resized_image_url(url, width, height, crop)
      image_url, image_id, image_width, image_height, image_crop, image_filename =
          url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]

      image_crop = crop ? '!' : ''

      "#{image_url}/files/#{image_id}/#{width}-#{height}#{image_crop}/#{image_filename}"
    end
end
