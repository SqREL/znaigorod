desc "Update image dimensions if not set (ignore images without thumbnail_url)"
task :update_image_dimensions => :environment do

  images = Image.scoped.select { |image| (image.width.nil? || image.height.nil?) && image.thumbnail_url.present? }

  puts "there is nothing to update!" and return if images.blank?

  bar = ProgressBar.new(images.count)
  images.each do |image|
    dimensions = FastImage.size(image.url)
    if dimensions.present?
      image.width = dimensions[0]
      image.height = dimensions[1]
      image.save!
    else
      puts "BROKEN URI: #{image.url}"
    end
    bar.increment!
  end

end
