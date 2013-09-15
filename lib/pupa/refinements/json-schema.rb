module Pupa
  class Refinements
    # A refinement for JSON Schema to validate "email" and "uri" formats.
    module Format
      # @see http://my.rails-royce.org/2010/07/21/email-validation-in-ruby-on-rails-without-regexp/
      def validate(current_schema, data, fragments, processor, validator, options = {})
        case current_schema.schema['format']
        when 'email'
          error_message = "The property '#{build_fragment(fragments)}' must be a valid email address"
          validation_error(processor, error_message, fragments, current_schema, self, options[:record_errors]) and return if !data.is_a?(String)
          address = Mail::Address.new(data)
          unless (address.address == data && address.domain && address.__send__(:tree).domain.dot_atom_text.elements.size > 1 rescue false)
            validation_error(processor, error_message, fragments, current_schema, self, options[:record_errors])
            return
          end
        when 'uri'
          error_message = "The property '#{build_fragment(fragments)}' must be a valid URI"
          validation_error(processor, error_message, fragments, current_schema, self, options[:record_errors]) and return if !data.is_a?(String)
          r = URI::DEFAULT_PARSER.regexp[:ABS_URI]
          unless r.match(data)
            validation_error(processor, error_message, fragments, current_schema, self, options[:record_errors])
            return
          end
        else
          super
        end
      end
    end

    class ::JSON::Schema::FormatAttribute
      class << self
        prepend Pupa::Refinements::Format
      end
    end
  end
end