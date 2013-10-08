require 'spec_helper'

describe PhishDotNetClient do
  let(:pnet) { PhishDotNetClient }
  let(:fake_api_key) { "fake-apikey" }

  def access_options(key)
    return pnet.class_variable_get(:@@options)[key]
  end

  it "pre-sets the api version to '2.0'" do
    expect(access_options(:api)).to eq('2.0')
  end

  it "pre-sets the response format to json" do
    expect(access_options(:format)).to eq('json')
  end

  describe "#apikey=" do
    it "sets the api key" do
      pnet.apikey = fake_api_key
      expect(access_options(:apikey)).to eq(fake_api_key)
    end
  end

  # describe "#authorize" do
  #   it "sets the username" do
  #     pnet.authorize('uzer', 'asdfasdf')
  #     expect(access_options(:username)).to eq('uzer')
  #   end
  # end

  describe "#clear_auth" do
    it "clears the apikey" do
      pnet.clear_auth
      expect(access_options(:apikey)).to be_nil
    end
  end

  # describe "#call_api_method" do
    # context "when the api_method is protected" do
    #   it "raises an error if no apikey is specified" do
    #     pnet.clear_auth
    #     expect{ pnet.call_api_method("pnet.shows.query") }.to raise_error
    #   end
    # end

  #   it "calls the api" do
  #     expect(pnet.call_api_method("pnet.shows.setlists.recent")).to_not be_nil
  #   end
  # end

  describe "#method_missing" do
    context "when the api method is a valid" do
      it "delegates to call_api_method" do
        expect{ pnet.method_missing :"pnet_shows_setlists_latest" }.not_to raise_error
      end
    end

    context "when the method name is not a valid api method" do
      it "passes the method_missing call on to super" do
        expect{ pnet.method_missing :"asdf_jkl" }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#get_api_method" do
    it "returns nil when the api_method doesn't exist" do
      expect(pnet.get_api_method('doesnt_exist')).to be_nil
    end

    it "returns the api method" do
      expect(pnet.get_api_method("pnet_api_authorize")).to eq("pnet.api.authorize")
    end

    it "adds the 'pnet.' prefix if it's not there" do
      expect(pnet.get_api_method("api_authorize")).to eq("pnet.api.authorize")
    end
  end

  # describe "#ensure_api_key" do
  #   it "raises an error if api_key isn't set" do
  #     expect{ pnet.ensure_api_key }.to raise_error
  #   end
  # end

  describe "#parse_setlistdata" do
    let(:parsed_setlist) { pnet.parse_setlistdata("<p class='pnetset pnetset1'><span class='pnetsetlabel'>Set 1:<\/span> <a href=\"http:\/\/phish.net\/song\/runaway-jim\">Runaway Jim<\/a><sup>[1]<\/sup>,  <a href=\"http:\/\/phish.net\/song\/foam\">Foam<\/a>,  <a href=\"http:\/\/phish.net\/song\/glide\">Glide<\/a>,  <a href=\"http:\/\/phish.net\/song\/split-open-and-melt\">Split Open and Melt<\/a>,  <a href=\"http:\/\/phish.net\/song\/if-i-could\">If I Could<\/a>,  <a href=\"http:\/\/phish.net\/song\/punch-you-in-the-eye\">Punch You In the Eye<\/a> >  <a href=\"http:\/\/phish.net\/song\/bathtub-gin\">Bathtub Gin<\/a>,  <a href=\"http:\/\/phish.net\/song\/scent-of-a-mule\">Scent of a Mule<\/a>,  <a href=\"http:\/\/phish.net\/song\/cavern\">Cavern<\/a><\/p><p class='pnetset pnetset2'><span class='pnetsetlabel'>Set 2:<\/span> <a href=\"http:\/\/phish.net\/song\/also-sprach-zarathustra\">Also Sprach Zarathustra<\/a><sup>[1]<\/sup> >  <a href=\"http:\/\/phish.net\/song\/sample-in-a-jar\">Sample in a Jar<\/a>,  <a href=\"http:\/\/phish.net\/song\/poor-heart\">Poor Heart<\/a><sup>[1]<\/sup> >  <a href=\"http:\/\/phish.net\/song\/mikes-song\">Mike's Song<\/a><sup>[1]<\/sup> ->  <a href=\"http:\/\/phish.net\/song\/simple\">Simple<\/a><sup>[1]<\/sup> ->  <a href=\"http:\/\/phish.net\/song\/mikes-song\">Mike's Song<\/a> >  <a href=\"http:\/\/phish.net\/song\/i-am-hydrogen\">I Am Hydrogen<\/a> >  <a href=\"http:\/\/phish.net\/song\/weekapaug-groove\">Weekapaug Groove<\/a>,  <a href=\"http:\/\/phish.net\/song\/harpua\">Harpua<\/a> ->  <a href=\"http:\/\/phish.net\/song\/kung\">Kung<\/a> ->  <a href=\"http:\/\/phish.net\/song\/harpua\">Harpua<\/a>,  <a href=\"http:\/\/phish.net\/song\/sparkle\">Sparkle<\/a> >  <a href=\"http:\/\/phish.net\/song\/big-ball-jam\">Big Ball Jam<\/a> >  <a href=\"http:\/\/phish.net\/song\/julius\">Julius<\/a> >  <a href=\"http:\/\/phish.net\/song\/frankenstein\">Frankenstein<\/a> <p class='pnetset pnetsete'><span class='pnetsetlabel'>Encore:<\/span> <a href=\"http:\/\/phish.net\/song\/sleeping-monkey\">Sleeping Monkey<\/a> >  <a href=\"http:\/\/phish.net\/song\/rocky-top\">Rocky Top<\/a> <p class='pnetfootnotes'>[1] O.J. reference.<br \/><\/p>") }
    it "parses the setlist" do
      expect(parsed_setlist).to eq(
        {})
    end
  end
end
