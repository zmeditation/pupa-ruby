module Pupa
  module Concerns
    # Adds the Popolo `created_at` and `updated_at` properties to a model. The
    # `created_at` and `updated_at` properties will automatically be set when
    # the object is inserted into or updated in the database.
    module Timestamps
      extend ActiveSupport::Concern

      included do
        attr_accessor :created_at, :updated_at
        dump :created_at, :updated_at

        set_callback(:create, :before) do |object|
          object.created_at = Time.now.utc
        end

        set_callback(:save, :before) do |object|
          # The object may not set created_at.
          # @see https://github.com/jpmckinney/pupa-ruby/issues/17
          object.created_at = object.document['created_at'] if object.document
          object.updated_at = Time.now.utc
        end
      end
    end
  end
end
