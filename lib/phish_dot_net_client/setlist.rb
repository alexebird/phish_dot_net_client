# encoding: utf-8

module PhishDotNetClient

  # This class represents the parsed data from the 'setlistdata' field.
  class Setlist

    # @!attribute [r] sets
    #   @return [Array<Set>] the setlist's sets
    attr_reader :sets

    # @!attribute [r] footnotes
    #   @return [Hash<Integer, Hash<Symbol, String>>] the setlist's footnotes
    attr_reader :footnotes

    # @param setlistdata [String] the setlistdata string
    #
    # @api private
    def initialize(setlistdata)
      @sets, @footnotes = self.class.parse_setlistdata(setlistdata)
    end

    # @return [Array<Song>] all songs in the setlist
    def songs
      return @sets.map(&:songs).reduce([]){|memo,songs| memo += songs }
    end

    # @api private
    #
    # Does the work of parsing the setlistdata.
    #
    # @param setlistdata [String] the setlistdata string
    #
    # @return [Array<(Array<Set>, Hash)>] the parsed sets and footnotes
    def self.parse_setlistdata(setlistdata)
      doc = Nokogiri::HTML(setlistdata)

      footnotes = {}
      footnotes_text = doc.css('.pnetfootnotes').first
      if footnotes_text
        footnotes_text = footnotes_text.content.split(/(?=\[\d+\])/)
        footnotes_text.each do |note|
          note.sub!(/\[(?<num>\d+)\]/, '').strip!
          num = $~[:num]
          footnotes[num.to_i] = { text: note }
        end
      end

      sets = []
      all_songs = []
      transitions_tokens = []
      slug_instances = {}

      setnodes = doc.css(".pnetset")
      position_in_show = 0

      setnodes.each_with_index do |n,set_index|
        setname = n.css(".pnetsetlabel").first.content
        set = Set.new(:name => setname.sub!(/:\z/, ''), :position => set_index)
        songs_doc = n.css("a")
        songs_doc.each_with_index do |song,song_index|
          position_in_set = song_index
          title = song.content
          url = song.attr('href')
          slug = URI.parse(url).path
          slug.sub!(/\A\/song\//, '')

          slug_instances[slug] ||= 0
          slug_instances[slug] += 1

          song = Song.new(:title => title,
                          :url => url,
                          :slug => slug,
                          :instance => slug_instances[slug],
                          :position_in_set => position_in_set,
                          :position_in_show => position_in_show)
          set.songs << song
          all_songs << song
          position_in_show += 1
        end

        transitions_text = n.content  # strips html tags
        transitions_tokens += tokenize_transitions_text(transitions_text, transitions_tokens)

        sets << set
      end

      augment_songs(transitions_tokens, all_songs, footnotes)

      return sets, footnotes
    end

    # @api private
    #
    # Adds footnotes to their associated songs and adds transition information
    # between songs.
    #
    # @param tokens [Array<Hash <Symbol, Object>>] the tokens to augment with
    # @param songs [Array<Song>] the songs to augment
    # @param footnotes [Hash<Integer, Hash<Symbol, String>>] the footnotes to augment with
    #
    # @return [void]
    def self.augment_songs(tokens, songs, footnotes)
      songs = Array.new(songs)  # make a copy

      get_song_by_title = lambda do |title,instance|
        songs.each do |song|
          if song.title == title && song.instance == instance
            return song
          end
        end
        raise "no song with that title ('#{title}')"
      end

      tokens.each_index do |i|
        prev_i = i >= 1 ? i - 1 : nil
        next_i = i < tokens.size - 1 ? i + 1 : nil

        token = tokens[i]
        case token[:type]
        when :note_ref
          prev_token = tokens[prev_i]
          song = get_song_by_title.call(prev_token[:title], prev_token[:instance])
          num = token[:number]
          footnotes[num][:song] = song
          song.footnotes << num
        when :transition
          prev_token = tokens[prev_i]
          if prev_token[:type] == :note_ref
            prev_token = tokens[prev_i-1]
          end
          next_token = tokens[next_i]
          from_song = get_song_by_title.call(prev_token[:title], prev_token[:instance])
          to_song = get_song_by_title.call(next_token[:title], next_token[:instance])
          PhishDotNetClient::SongTransition.new(token[:transition_type], from_song, to_song)
        end
      end
    end

    # @api private
    #
    # Tokenizes the html-stripped setlistdata text.
    #
    # @param transitions_text [String] the text to tokenize
    # @param existing_tokens [Array<Hash<Symbol, Object>>] tokens of already
    #   parsed text, so that repeat songs can be detected.
    #
    # @raise [RuntimeError] if the transitions_text could not be parsed
    #
    # @return [Array<Hash<Symbol, Object>>]
    def self.tokenize_transitions_text(transitions_text, existing_tokens=[])
      rules = []

      # Account for multiple songs with the same title in a song list
      song_title_counts = {}
      existing_tokens.each do |token|
        if token[:type] == :song
          title = token[:title]
          song_title_counts[title] ||= 0
          song_title_counts[title] += 1
        end
      end

      rules.push(/\A[a-z0-9\s]+:/i => lambda do |match|
        return { type: :set_name, name: match.to_s.strip.sub(':', '') }
      end)

      rules.push(/\A[äa-z0-9\-?\.!:\/'\s\(\)]+[a-z0-9\)?!']/i => lambda do |match|
        title = match.to_s.strip
        song_title_counts[title] ||= 0
        song_title_counts[title] += 1
        return { type: :song, title: title, instance: song_title_counts[title] }
      end)

      rules.push(/\A\[(?<num>\d+)\]/ => lambda do |match|
        return { type: :note_ref, number: match[:num].to_i }
      end)

      rules.push(/\A,/ => lambda do |match|
        return { type: :transition, transition_type: :no_segue }
      end)

      rules.push(/\A>/ => lambda do |match|
        return { type: :transition, transition_type: :segue }
      end)

      rules.push(/\A->/ => lambda do |match|
        return { type: :transition, transition_type: :deep_segue }
      end)

      rules.push(/\A\s+/ => lambda do |match|
        return nil
      end)

      parsed_set = []

      until transitions_text.empty?
        matched = false  # keeps track of whether the transitions_text matched
                         # any rule. raise error if there no match.

        rules.each do |rule|
          rule_regex, processor = rule.keys.first, rule.values.first

          if transitions_text.slice!(rule_regex)
            matched = true
            token = processor.call($~)
            parsed_set.push(token) if token
            break
          end
        end

        raise "could not parse: '#{transitions_text}'" unless matched
      end

      return parsed_set
    end
  end
end
