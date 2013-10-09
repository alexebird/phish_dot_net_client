require 'spec_helper'

describe PhishDotNetClient do
  let(:pnet) { PhishDotNetClient }
  let(:fake_api_key) { "fake-apikey" }

  def access_default_params(key)
    return pnet.class_variable_get(:@@default_params)[key]
  end

  it "pre-sets the api version to '2.0'" do
    expect(access_default_params(:api)).to eq('2.0')
  end

  it "pre-sets the response format to json" do
    expect(access_default_params(:format)).to eq('json')
  end

  describe "#apikey=" do
    it "sets the api key" do
      pnet.apikey = fake_api_key
      expect(access_default_params(:apikey)).to eq(fake_api_key)
    end
  end

  # describe "#authorize" do
  #   it "sets the username" do
  #     pnet.authorize('uzer', 'asdfasdf')
  #     expect(access_default_params(:username)).to eq('uzer')
  #   end
  # end

  describe "#clear_auth" do
    before(:each) do
      pnet.clear_auth
    end

    it "clears the apikey" do
      expect(access_default_params(:apikey)).to be_nil
    end

    it "clears the authkey" do
      expect(access_default_params(:authkey)).to be_nil
    end

    it "clears the username" do
      expect(access_default_params(:username)).to be_nil
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

    # context "when the method name is not a valid api method" do
    #   it "passes the method_missing call on to super" do
    #     expect{ pnet.method_missing :"asdf_jkl" }.to raise_error(NoMethodError)
    #   end
    # end
  end

  describe "#get_api_method" do
    # it "returns nil when the api_method doesn't exist" do
    #   expect(pnet.get_api_method('doesnt_exist')).to be_nil
    # end

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
end
