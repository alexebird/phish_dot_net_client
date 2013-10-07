# encoding: utf-8

require 'restclient'
require 'json'

require 'phish_dot_net_client/version'

# @todo write doc
module PhishDotNetClient
  extend self

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

  # "https://api.phish.net/api.js?api=2.0&method=pnet.shows.query&format=json&apikey=920FF765772E442F3E22&year=2011"

  @@options = { :api    => "2.0",
                :format => "json" }

  # @todo write doc
  def authorize(private_api_key)
    @@options.merge!(:apikey => private_api_key)
  end

  def clear_auth
    @@options.delete(:apikey)
  end

  # @param opts [Hash] the options for the api call
  # @option opts [String] :method the method to call
  # @option opts [Hash] :args the method arguments
  # @option
  #
  # @todo write doc
  def call_api_method(api_method, args={})
    method_data = API_METHODS[api_method]
    ensure_api_key if method_data[:scope] == "protected"

    args.merge!(:method => api_method)
    response = RestClient.get BASE_URL, { :params => @@options.merge(args) }

    if response.code < 200 || response.code > 299
      raise "non 2xx reponse: status=#{response.code}"
    end

    return JSON.parse(response)
  end

  def method_missing(name, *args)
    api_method = get_api_method(name)

    if api_method
      call_api_method(api_method, *args)
    else
      super(name, *args)
    end
  end

  # private

  def get_api_method(rb_method_name)
    api_method_name = rb_method_name.to_s.gsub("_", ".")

    if API_METHODS.has_key?(api_method_name)
      return api_method_name
    else
      return nil
    end
  end

  def ensure_api_key
    raise "api key is required" if @@options[:apikey].nil?
  end
end
