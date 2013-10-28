# encoding: utf-8

module PhishDotNetClient

  # This class represents a set from the 'setlistdata' field.
  class Song

    # @!attribute [r] title
    #   @return [String] the song title
    attr_reader :title

    # @!attribute [r] url
    #   @return [String] the song url
    attr_reader :url

    # @!attribute [r] slug
    #   @return [String] the song slug (not unique). slug+instance can be used to
    #     create a unique slug when the setlist has the same song more than once.
    attr_reader :slug

    # @!attribute [r] instance
    #   @return [Integer] the instance number of the song. Normally will be +1+ since
    #     most shows don't have multiple instances of the same song.
    attr_reader :instance

    # @!attribute [r] position_in_set
    #   @return [String] the position of the song in it's set, indexed starting at 0
    attr_reader :position_in_set

    # @!attribute [r] position_in_show
    #   @return [String] the position of the song in the show, indexed starting at 0
    attr_reader :position_in_show

    # @!attribute [r] footnotes
    #   @return [Array<Integer>] the song's foonote numbers, used to lookup footnotes
    #     via {Setlist#footnotes}.
    attr_reader :footnotes

    # @!attribute pre_transition
    #   @return [SongTransition] the transition to the previous song
    attr_accessor :pre_transition

    # @!attribute post_transition
    #   @return [SongTransition] the transition to the next song
    attr_accessor :post_transition

    # @api private
    #
    # @param  attrs [Hash<Symbol, Object>] the song attributes
    # @option attrs [String] :title the song title
    # @option attrs [String] :url the song url
    # @option attrs [String] :slug the song slug
    # @option attrs [Integer] :instance the instance number of the song
    # @option attrs [Integer] :position_in_set set position of the song
    # @option attrs [Integer] :position_in_show show position of the song
    def initialize(attrs={})
      @title = attrs[:title]
      @url = attrs[:url]
      @slug = attrs[:slug]
      @instance = attrs[:instance]
      @position_in_set = attrs[:position_in_set]
      @position_in_show = attrs[:position_in_show]
      @footnotes = []
    end

    # @return [String] the song along with pre and post transitions
    def to_s
      s = StringIO.new

      if pre_transition
        s.print "#{pre_transition.from_song.title}(#{pre_transition.from_song.instance})..."
      else
        s.print "x..."
      end

      s.print "#{@title}(#{@instance})"

      if post_transition
        s.puts "...#{post_transition.to_song.title}(#{post_transition.to_song.instance})"
      else
        s.puts "...x"
      end

      s.puts
      return s.string
    end
  end
end
