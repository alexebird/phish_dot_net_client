# encoding: utf-8

module PhishDotNetClient
  class Song
    # include Comparable

    attr_reader :title
    attr_reader :url
    attr_reader :slug
    attr_reader :instance
    attr_reader :position_in_set
    attr_reader :position_in_show
    attr_reader :footnotes
    attr_accessor :pre_transition
    attr_accessor :post_transition

    def initialize(attrs={})
      @title = attrs[:title]
      @url = attrs[:url]
      @slug = attrs[:slug]
      @instance = attrs[:instance]
      @position_in_set = attrs[:position_in_set]
      @position_in_show = attrs[:position_in_show]
      @footnotes = []
    end

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


    # def <=>(other_obj)
    #   return nil unless other_obj.is_a?(Song)

    #   return @position_in_show <=> other_obj.position_in_show
    # end

    # def ==(other_obj)
    #   return nil unless other_obj.is_a?(Song)

    #   return @title == other_obj.title && @position_in_show == other_obj.position_in_show
    # end
  end
end
