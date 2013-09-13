module Pupa
  module Concerns
    module Nameable
      extend ActiveSupport::Concern

      included do
        attr_accessor :other_names
      end

      # Adds an alternate or former name.
      #
      # @param [String] name an alternate or former name
      # @param [Date,Time] start_date the date on which the name was adopted
      # @param [Date,Time] end_date the date on which the name was abandoned
      # @param [String] note a note, e.g. "Birth name"
      def add_name(name, start_date: nil, end_date: nil, note: nil)
        data = {name: name}
        if start_date
          data[:start_date] = start_date
        end
        if end_date
          data[:end_date] = end_date
        end
        if note
          data[:note] = note
        end
        if name
          (@other_names ||= []) << data
        end
      end
    end
  end
end
