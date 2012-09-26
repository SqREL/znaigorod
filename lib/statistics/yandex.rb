require 'curb'

module Statistics
  class Yandex
    def update_affiches
      results.each do |e|
        affiche = Affiche.find_by_slug(e['slug'])

        unless affiche
          puts "Affiche with slug #{e['slug']} not found"
          next
        end

        affiche.update_attribute :yandex_metrika_page_views, e['page_views']
      end
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
      'eb08c9816dcd493b8d2a22c3fc42bf5f'
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
      JSON.parse(Curl.get(request_url).body_str)
    end

    def selected_elements
      response_hash['data'].
        select { |h| h['url'] =~ /(concert|exhibition|movie|other|party|spectacle|sportsevent)\// }
    end

    def remove_anchor(url)
      url.gsub(/#.*/, '')
    end

    def popular
      @popular ||= selected_elements.map { |e|
        { 'url' => remove_anchor(e['url']), 'page_views' => e['page_views'].to_i }
      }
    end

    def slug_from(url)
      url.split('/').last
    end

    def results
      popular.map { |e|
        { 'slug' => slug_from(e['url']), 'page_views' => e['page_views'] }
      }
    end
  end
end
