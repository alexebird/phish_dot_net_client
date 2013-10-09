require 'spec_helper'

describe PhishDotNetClient::Song do
  let(:song) { PhishDotNetClient::Song }
  let(:song_instance) { song.new }

  %w[title url slug instance position_in_set position_in_show footnotes pre_transition post_transition].each do |attr|
    it "has a #{attr} attribute" do
      expect(song_instance.respond_to? attr.to_sym).to be_true
    end
  end

  describe "#initialize" do
    it "sets the attributes" do
      s = song.new(:title => 'title', :url => 'http://url', :slug => "slug", :instance => "inst",
        :position_in_set => 3, :position_in_show => 5)
      expect(s.title).to eq('title')
      expect(s.url).to eq('http://url')
      expect(s.slug).to eq('slug')
      expect(s.instance).to eq('inst')
      expect(s.position_in_set).to eq(3)
      expect(s.position_in_show).to eq(5)
    end
  end
end
