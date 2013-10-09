require 'spec_helper'

describe PhishDotNetClient::Set do
  let(:set) { PhishDotNetClient::Set }
  let(:set_instance) { set.new }

  %w[position name songs].each do |attr|
    it "has a #{attr} attribute" do
      expect(set_instance.respond_to? attr.to_sym).to be_true
    end
  end
end
