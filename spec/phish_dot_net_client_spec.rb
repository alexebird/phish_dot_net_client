require 'spec_helper'

describe PhishDotNetClient do
  let(:pnet) { PhishDotNetClient }

  def access_options(key)
    return pnet.class_variable_get(:@@options)[key]
  end

  it "pre-sets the api version to '2.0'" do
    expect(access_options(:api_version)).to eq('2.0')
  end

  it "pre-sets the response format to json" do
    expect(access_options(:format)).to eq('json')
  end

  describe "#authorize" do
    let(:api_key) { "2eda08q234jkladfs07923fwae" }

    it "sets the api key" do
      pnet.authorize(api_key)
      expect(access_options(:api_key)).to eq(api_key)
    end
  end

  describe "#call_api_method" do
    it "" do
      
    end
  end

  describe "#ensure_api_key" do
    it "raises an error if api_key isn't set" do
      expect{ pnet.ensure_api_key }.to raise_error
    end
  end
end
