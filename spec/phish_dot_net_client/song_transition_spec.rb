require 'spec_helper'

describe PhishDotNetClient::SongTransition do
  let(:from_song) { PhishDotNetClient::Song.new(:title => "Song 1") }
  let(:to_song) { PhishDotNetClient::Song.new(:title => "Song 2") }
  let(:song_trans) { PhishDotNetClient::SongTransition }
  let!(:song_trans_instance) { PhishDotNetClient::SongTransition.new(:deep_segue, from_song, to_song) }

  %w[type from_song to_song].each do |attr|
    it "has a #{attr} attribute" do
      expect(song_trans_instance.respond_to? attr.to_sym).to be_true
    end
  end

  describe "#initialize" do
    it "sets the attributes" do
      expect(song_trans_instance.type).to eq(:deep_segue)
      expect(song_trans_instance.from_song).to eq(from_song)
      expect(song_trans_instance.to_song).to eq(to_song)
    end

    it "sets the songs transitions" do
      expect(from_song.post_transition).to eq(song_trans_instance)
      expect(to_song.pre_transition).to eq(song_trans_instance)
    end
  end
end
