module PresentsAsCheckboxes
  extend ActiveSupport::Concern

  module ClassMethods
    def presents_as_checkboxes(*args)
      options = args.extract_options!
      field = args.first

      attr_accessor "#{field}_list"
      attr_accessible "#{field}_list"

      define_method "available_#{field.to_s.pluralize}" do
        options[:available_values].call if options[:available_values]
      end

      define_method "set_#{field}" do
        self.send "#{field}=", self.send("#{field}_list").delete_if(&:blank?).join(', ') if self.send("#{field}_list")
      end

      before_validation "set_#{field}", :if => "#{field}_list?"

      define_method field.to_s.pluralize do
        (self.send(field) || '').split(',').map(&:squish)
      end

      define_method "#{field}_list?" do
        !!self.send("#{field}_list")
      end

      if options[:validates_presence]
        message = options[:message] || I18n.t('activerecord.errors.messages.blank')
        validates_presence_of "#{field}_list", :message => message
      end
    end
  end
end
