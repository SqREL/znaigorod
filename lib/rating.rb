module Rating
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :association_names

    def use_for_rating(*args)
      @association_names = args
    end
  end

  def own_rating
    attribute_names.inject(0) { |sum, attribute| sum += 1 if send("#{attribute}?"); sum } / attribute_names.count.to_f
  end

  def association_ratings
    self.class.association_names.map { |association_name|
      [*(send association_name)].inject(0) { |sum, obj| sum += obj.summary_rating if obj.respond_to?(:summary_rating); sum }
    }.sum
  end

  def summary_rating
    result = own_rating
    result += association_ratings if self.class.association_names

    result
  end
end
