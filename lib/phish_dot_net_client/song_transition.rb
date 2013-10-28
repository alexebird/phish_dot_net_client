# encoding: utf-8

module PhishDotNetClient

  # This class represents a transition between two songs.
  class SongTransition

    # @!attribute [r] type
    #
    #  Valid types:
    #  * :no_segue
    #  * :segue (aka '>')
    #  * :deep_segue (aka '->')
    #
    #   @return [Symbol] the transition type
    attr_reader :type

    # @!attribute [r] from_song
    #   @return [Song] the song going into the transition
    attr_reader :from_song

    # @!attribute [r] to_song
    #   @return [Song] the song going out the transition
    attr_reader :to_song

    # @api private
    #
    # @param type [Symbol] the transition type
    # @param from_song [Song] the from song
    # @param to_song [Song] the to song
    def initialize(type, from_song, to_song)
      @type = type
      @from_song = from_song
      @to_song = to_song
      @from_song.post_transition = @to_song.pre_transition = self
    end
  end
end
