class Movie < Affiche
  attr_accessible

  before_save :set_wmode_for_trailer

  private
    def set_wmode_for_trailer
      self.trailer_code.gsub!(/(object|embed)/, '\1 wmode="opaque"')
    end
end

# == Schema Information
#
# Table name: affiches
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  description    :text
#  original_title :string(255)
#  poster_url     :string(255)
#  trailer_code   :text
#  type           :string(255)
#  tag            :text
#  vfs_path       :string(255)
#  image_url      :string(255)
#

