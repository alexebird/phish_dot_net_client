# encoding: utf-8

module PhishDotNetClient
  class SongTransition

    attr_reader :type
    attr_reader :from_song
    attr_reader :to_song

    def initialize(type, from_song, to_song)
      @type = type
      @from_song = from_song
      @to_song = to_song
      @from_song.post_transition = @to_song.pre_transition = self
    end
  end
end
