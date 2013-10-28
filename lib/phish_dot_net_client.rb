# encoding: utf-8

require 'restclient'
require 'oj'
require 'nokogiri'

require 'phish_dot_net_client/version'
require 'phish_dot_net_client/set'
require 'phish_dot_net_client/setlist'
require 'phish_dot_net_client/song'
require 'phish_dot_net_client/song_transition'

# This module encapsulates interaction with the Phish.net API. It allows you to
# call any API method and will parse "setlistdata" fields in the JSON responses.
module PhishDotNetClient
  extend self

  # The possible API methods. Generated from +rake parse_method_docs+.
  API_METHODS =
    {
      "pnet.api.authkey.get"        => { :scope => "protected" },
      "pnet.api.authorize"          => { :scope => "protected" },
      "pnet.api.authorized.check"   => { :scope => "protected" },
      "pnet.api.isAuthorized"       => { :scope => "protected" },
      "pnet.artists.get"            => { :scope => "public" },
      "pnet.blog.get"               => { :scope => "public" },
      "pnet.blog.item.get"          => { :scope => "public" },
      "pnet.collections.get"        => { :scope => "protected" },
      "pnet.collections.query"      => { :scope => "protected" },
      "pnet.forum.canpost"          => { :scope => "protected" },
      "pnet.forum.get"              => { :scope => "public" },
      "pnet.forum.thread.get"       => { :scope => "protected" },
      "pnet.forum.thread.new"       => { :scope => "protected" },
      "pnet.forum.thread.respond"   => { :scope => "protected" },
      "pnet.news.comments.get"      => { :scope => "public" },
      "pnet.news.get"               => { :scope => "public" },
      "pnet.reviews.query"          => { :scope => "protected" },
      "pnet.reviews.recent"         => { :scope => "public" },
      "pnet.shows.links.get"        => { :scope => "protected" },
      "pnet.shows.query"            => { :scope => "protected" },
      "pnet.shows.setlists.get"     => { :scope => "protected" },
      "pnet.shows.setlists.latest"  => { :scope => "public" },
      "pnet.shows.setlists.random"  => { :scope => "public" },
      "pnet.shows.setlists.recent"  => { :scope => "public" },
      "pnet.shows.setlists.tiph"    => { :scope => "public" },
      "pnet.shows.upcoming"         => { :scope => "public" },
      "pnet.user.get"               => { :scope => "protected" },
      "pnet.user.myshows.add"       => { :scope => "protected" },
      "pnet.user.myshows.get"       => { :scope => "protected" },
      "pnet.user.myshows.remove"    => { :scope => "protected" },
      "pnet.user.register"          => { :scope => "protected" },
      "pnet.user.shows.rate"        => { :scope => "protected" },
      "pnet.user.uid.get"           => { :scope => "protected" },
      "pnet.user.username.check"    => { :scope => "protected" }
    }

  # The base URL for API calls
  BASE_URL = "https://api.phish.net/api.js"

  # "https://api.phish.net/api.js?api=2.0&method=pnet.shows.query&format=json&apikey=XXX&year=2011"

  # Default API parameters
  DEFAULT_PARAMS = { api: "2.0",
                  format: "json" }

  # Set the apikey. The "private api key" from your Phish.net account should be
  # used.
  #
  # @param private_api_key [String] the apikey
  # @return [void]
  def apikey=(private_api_key)
    DEFAULT_PARAMS.merge!(:apikey => private_api_key)
  end

  # Calls pnet.api.authorize with the specified username and password, then stores
  # the username and returned authkey if the call was successful. The password is
  # not stored.
  #
  # @param username [String] the username
  # @param password [String] the password
  #
  # @return [void]
  def authorize(username, password)
    resp = call_api_method("pnet.api.authorize", :username => username, :passwd => password)

    if resp['success'] == 1 && resp.has_key?('authkey')
      DEFAULT_PARAMS.merge!(:username => username, :authkey => resp['authkey'])
    end
  end

  # Clears the stored API authentication parameters (apikey, username, authkey)
  #
  # @return [void]
  def clear_auth
    [:apikey, :username, :authkey].each { |key| DEFAULT_PARAMS.delete(key) }
  end

  # @api private
  #
  # Calls the specified Phish.net api method.
  #
  # @param api_method [String] the method to call
  # @param params [Hash] the url parameters for the api call
  #
  # @raise [RuntimeError] if the http response status is a 2xx
  #
  # @return [Hash, Array] the parsed JSON of API response
  def call_api_method(api_method, params={})
    # method_data = API_METHODS[api_method]
    # ensure_api_key if method_data[:scope] == "protected"

    params.merge!(:method => api_method)
    response = RestClient.get BASE_URL, { :params => DEFAULT_PARAMS.merge(params) }

    if response.code < 200 || response.code > 299
      raise "non 2xx reponse: status=#{response.code}"
    end

    parsed = Oj.load(response)

    if parsed.is_a?(Array)
      parsed.each do |obj|
        obj["setlistdata"] = Setlist.new(obj["setlistdata"]) if obj.has_key?("setlistdata")
      end
    elsif parsed.is_a?(Hash)
      parsed["setlistdata"] = Setlist.new(parsed["setlistdata"]) if parsed.has_key?("setlistdata")
    end

    return parsed
  end

  # Override method_missing to provide mapping of Ruby methods to API method names.
  #
  # @api private
  def method_missing(name, *args)
    api_method = get_api_method(name)

    if api_method
      call_api_method(api_method, *args)
    else
      super(name, *args)
    end
  end

  # @api private
  # @param rb_method_name [Symbol] the Ruby method name
  # @return [String] the api method name
  def get_api_method(rb_method_name)
    api_method_name = rb_method_name.to_s.gsub("_", ".")

    unless api_method_name.match(/\Apnet\./)
      api_method_name = 'pnet.' + api_method_name
    end

    return api_method_name

    # if API_METHODS.has_key?(api_method_name)
    #   return api_method_name
    # else
    #   return nil
    # end
  end

  # def ensure_api_key
  #   raise "api key is required" if DEFAULT_PARAMS[:apikey].nil?
  # end
end
