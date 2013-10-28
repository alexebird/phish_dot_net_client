# encoding: utf-8

module PhishDotNetClient

  # This class represents a set from the 'setlistdata' field.
  class Set

    # @!attribute [r] position
    #   @return [Integer] the position of the set, indexed starting at 0
    attr_reader :position

    # @!attribute [r] name
    #   @return [String] the name of the set
    attr_reader :name

    # @!attribute [r] songs
    #   @return [Array<Song>] the songs belonging to the set
    attr_reader :songs

    # @param attrs [Hash] the attributes hash
    # @option attrs [Integer] :position the set position
    # @option attrs [Integer] :name the set name
    #
    # @api private
    def initialize(attrs={})
      @songs = []
      @position = attrs[:position]
      @name = attrs[:name]
    end
  end
end
