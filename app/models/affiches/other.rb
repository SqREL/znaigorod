class Other < Affiche
end

# == Schema Information
#
# Table name: affiches
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  description               :text
#  original_title            :string(255)
#  poster_url                :string(255)
#  trailer_code              :text
#  type                      :string(255)
#  tag                       :text
#  vfs_path                  :string(255)
#  image_url                 :string(255)
#  distribution_starts_on    :datetime
#  distribution_ends_on      :datetime
#  slug                      :string(255)
#  constant                  :boolean
#  yandex_metrika_page_views :integer
#  vkontakte_likes           :integer
#  vk_aid                    :string(255)
#  yandex_fotki_url          :string(255)
#  popularity                :float
#

