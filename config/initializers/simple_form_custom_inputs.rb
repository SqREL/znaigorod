module SimpleForm
  module Inputs
    class DatePickerInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options.merge(datepicker_options(object.send(attribute_name))))
      end

      def datepicker_options(value = nil)
        datepicker_options = {:value => value.nil?? nil : I18n.localize(value)}
      end
    end
  end
end
