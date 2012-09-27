require 'vkontakte_api'

module Statistics
  VkontakteApi.log_errors = false
  VkontakteApi.log_requests = false

  class Vkontakte
    def update_affiches
      pb = ProgressBar.new(likes_with_slugs.size)
      puts 'Updating affiches...'

      likes_with_slugs.each do |e|
        affiche = Affiche.find_by_slug(e.slug)

        unless affiche
          puts "Affiche with slug #{e.slug} not found"
          next
        end

        puts "Affiche with slug #{e.slug} has #{e.likes} likes"
        affiche.update_attribute :vkontakte_likes, e.likes
        pb.increment!
      end
    end

    private

    def vk_client
      @vk_client ||= VkontakteApi::Client.new
    end

    def type
      'sitepage'
    end

    def owner_id
      '3136085'
    end

    def likes_for(page_url)
      begin
        return vk_client.likes.get_list(type: type, owner_id: owner_id, page_url: page_url)['count']
      rescue VkontakteApi::Error => e
        return 0
      end
    end

    def likes_with_slugs
      @likes_with_slugs ||= [].tap { |array|
        puts 'Getting data from Vk...'

        urls.each do |url|
          slug = url.split('/').last
          likes = likes_for(url)

          array << Hashie::Mash.new(slug: slug, likes: likes) unless likes.zero?
        end
      }
    end

    def urls
      Yandex.new.urls
    end
  end
end
