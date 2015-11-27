module Pupa
  # A geographic area whose geometry may change over time.
  class Area
    include Model

    self.schema = 'schemas/popolo/area.json'

    include Concerns::Timestamps
    include Concerns::Sourceable

    attr_accessor :name, :identifier, :classification, :parent_id, :geometry
    dump          :name, :identifier, :classification, :parent_id, :geometry

    foreign_key :parent_id

    # Returns the area's name.
    #
    # @return [String] the area's name
    def to_s
      name
    end
  end
end
