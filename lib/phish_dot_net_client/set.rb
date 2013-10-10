# encoding: utf-8

# @api private
module PhishDotNetClient
  class Set

    attr_reader :position
    attr_reader :name
    attr_reader :songs

    def initialize(attrs={})
      @songs = []
      @position = attrs[:position]
      @name = attrs[:name]
    end
  end
end
