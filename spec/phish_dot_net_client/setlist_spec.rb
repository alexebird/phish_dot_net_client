require 'spec_helper'

describe PhishDotNetClient::Setlist do
  # Test setlistdata:
  # Set 1: Runaway Jim[1], Foam, Punch You In the Eye[2] > Bathtub Gin, Cavern
  # Set 2: Also Sprach Zarathustra -> Cavern
  # Encore: Sleeping Monkey
  let(:setlistdata) { "<p class='pnetset pnetset1'><span class='pnetsetlabel'>Set 1:<\/span> <a href=\"http:\/\/phish.net\/song\/runaway-jim\">Runaway Jim<\/a><sup>[1]<\/sup>,  <a href=\"http:\/\/phish.net\/song\/foam\">Foam<\/a>,  <a href=\"http:\/\/phish.net\/song\/punch-you-in-the-eye\">Punch You In the Eye<\/a><sup>[2]<\/sup> >  <a href=\"http:\/\/phish.net\/song\/bathtub-gin\">Bathtub Gin<\/a>,  <a href=\"http:\/\/phish.net\/song\/cavern\">Cavern<\/a><\/p><p class='pnetset pnetset2'><span class='pnetsetlabel'>Set 2:<\/span> <a href=\"http:\/\/phish.net\/song\/also-sprach-zarathustra\">Also Sprach Zarathustra<\/a> ->  <a href=\"http:\/\/phish.net\/song\/cavern\">Cavern<\/a> <p class='pnetset pnetsete'><span class='pnetsetlabel'>Encore:<\/span> <a href=\"http:\/\/phish.net\/song\/sleeping-monkey\">Sleeping Monkey<\/a> <p class='pnetfootnotes'>[1] O.J. reference.<br \/>[2] \"Anti-drum solo.\"<br \/><\/p>" }
  let(:setlist) { PhishDotNetClient::Setlist }
  let(:setlist_instance) { setlist.new(setlistdata) }
  let(:setlist_dumb_instance) { setlist.new('') }

  it "has a sets attribute" do
    expect(setlist_dumb_instance.respond_to? :sets).to be_true
  end

  it "has a footnotes attribute" do
    expect(setlist_dumb_instance.respond_to? :footnotes).to be_true
  end

  describe "#initialize" do
    it "sets the sets" do
      expect(setlist_instance.sets).to be_instance_of(Array)
    end
  end

  describe ".parse_setlistdata" do
    let(:parsed_setlist) { setlist.parse_setlistdata(setlistdata) }

    it "returns Array(sets), Hash(footnotes)" do
      expect(parsed_setlist).to be_instance_of(Array)
      sets = parsed_setlist.first
      expect(sets).to be_instance_of(Array)
      notes = parsed_setlist.last
      expect(notes).to eq({ 1 => { text: %[O.J. reference.], song: sets[0].songs[0] },
                            2 => { text: %["Anti-drum solo."], song: sets[0].songs[2] } })

      set1 = sets[0]
      expect(set1).to be_instance_of(PhishDotNetClient::Set)
      set1.songs.each do |song|
        expect(song).to be_instance_of(PhishDotNetClient::Song)
      end

      set2 = sets[1]
      expect(set2).to be_instance_of(PhishDotNetClient::Set)
      set2.songs.each do |song|
        expect(song).to be_instance_of(PhishDotNetClient::Song)
      end

      encore = sets[2]
      expect(encore).to be_instance_of(PhishDotNetClient::Set)
      encore.songs.each do |song|
        expect(song).to be_instance_of(PhishDotNetClient::Song)
      end
    end
  end

  describe "#songs" do
    it "returns all songs" do
      expect(setlist_instance.songs.size).to eq(8)
    end
  end

  describe ".augment_songs" do
    let(:song1) { PhishDotNetClient::Song.new(:title => "Song 1", :instance => 1) }
    let(:song2) { PhishDotNetClient::Song.new(:title => "Song 2", :instance => 1) }
    let(:song1again) { PhishDotNetClient::Song.new(:title => "Song 1", :instance => 2) }
    let(:transitions_tokens) { setlist.tokenize_transitions_text("Set 1: Song 1[1] > Song 2 -> Song 1") }
    let(:footnotes) { { 1 => { text: %[O.J. reference.] },
                        2 => { text: %["Anti-drum solo."] } } }

    it "adds transitions to the songs" do
      setlist.augment_songs(transitions_tokens, [song1, song2, song1again], footnotes)
      expect(song1.post_transition).to be_instance_of(PhishDotNetClient::SongTransition)
      expect(song1.post_transition).to eq(song2.pre_transition)
      expect(song1.post_transition.type).to eq(:segue)
    end

    it "accounts for songs with the same title" do
      setlist.augment_songs(transitions_tokens, [song1, song2, song1again], footnotes)
      expect(song2.post_transition).to eq(song1again.pre_transition)
      expect(song2.post_transition.type).to eq(:deep_segue)
    end

    it "adds notes to the songs" do
      setlist.augment_songs(transitions_tokens, [song1, song2, song1again], footnotes)
      expect(song1.footnotes).to eq([1])
    end
  end

  describe ".tokenize_transitions_text" do
    let(:setlist_str) { "Set 1: Runaway Jim[1] ->  Foam,  Punch You In the Eye[2] >  Bathtub Gin, Foam" }
    let(:parsed_text) { setlist.tokenize_transitions_text(setlist_str) }

    it "parses the set's text" do
      expect(parsed_text).to eq([
       { type: :set_name, name: "Set 1" },
       { type: :song, title: "Runaway Jim", instance: 1 },
       { type: :note_ref, number: 1 },
       { type: :transition, transition_type: :deep_segue },
       { type: :song, title: "Foam", instance: 1  },
       { type: :transition, transition_type: :no_segue },
       { type: :song, title: "Punch You In the Eye", instance: 1  },
       { type: :note_ref, number: 2 },
       { type: :transition, transition_type: :segue },
       { type: :song, title: "Bathtub Gin", instance: 1  },
       { type: :transition, transition_type: :no_segue },
       { type: :song, title: "Foam", instance: 2  }
       ])
    end

    it "raises an error for unparsable text" do
      expect{ setlist.tokenize_transitions_text("asdf !@###") }.to raise_error
    end
  end
end
