require 'curb'

module Statistics
  class Yandex
    def update_affiches
      pb = ProgressBar.new(slugs_with_page_views.size)
      puts 'Updating affiches...'

      slugs_with_page_views.each do |slug, page_views|
        pb.increment!
        affiche = Affiche.find_by_slug(slug)

        next unless affiche

        affiche.yandex_metrika_page_views = page_views
        affiche.save!
      end
    end

    def urls
      selected_elements.map(&:url)
    end

    private

    def api_url
      'http://api-metrika.yandex.ru'
    end

    def method_name
      'stat/content/popular'
    end

    def results_format
      'json'
    end

    def oauth_token
      Settings['yandex.oauth_token']
    end

    def counter_id
      '14923525'
    end

    def per_page
      5000
    end

    def params
      CGI.unescape(
        { oauth_token: oauth_token, id: counter_id, per_page: per_page }.to_query
      )
    end

    def request_url
      "#{api_url}/#{method_name}.#{results_format}?#{params}"
    end

    def response_hash
      Hashie::Mash.new JSON.parse(Curl.get(request_url).body_str)
    end

    def remove_anchor(url)
      url.gsub(/#.*/, '')
    end

    def selected_elements
      response_hash.data.
        select { |h| h.url =~ /(concert|exhibition|movie|other|party|spectacle|sportsevent)\// }.tap { |hash|
          hash.each do |e|
            url = remove_anchor(e.url)

            next unless Affiche.with_showings.find_by_slug(slug_from(url))

            e.url = url
            e.page_views = e.page_views.to_i
          end
        }
    end

    def slug_from(url)
      url.split('/').last
    end

    def slugs_with_page_views
      @slugs_with_page_views ||= {}.tap { |hash|
        selected_elements.each do |e|
          hash[slug_from(e.url)] = [hash[slug_from(e.url)].to_i, e.page_views].max
        end
      }
    end
  end
end
