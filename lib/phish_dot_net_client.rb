# encoding: utf-8

require 'restclient'

require 'phish_dot_net_client/version'

# @todo write doc
module PhishDotNetClient
  extend self

  # The base URL for API calls
  BASE_URL = "https://api.phish.net/api.js?"

  # "https://api.phish.net/api.js?api=2.0&method=pnet.shows.query&format=json&apikey=920FF765772E442F3E22&year=2011"

  @@options = { :api_version => "2.0",
                :format      => "json" }

  # @todo write doc
  def authorize(private_api_key)
    @@options.merge!(:api_key => private_api_key)
  end

  # @param opts [Hash] the options for the api call
  # @option opts [String] :method the method to call
  # @option opts [Hash] :args the method arguments
  # @option
  #
  # @todo write doc
  def call_api_method(opts={})
  end

  def build_api_url()
  end

  private

  # @todo write doc
  def ensure_api_key
    raise "api key is required" unless @@options[:private_api_key]
  end
end
