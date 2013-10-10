# Phish.net API Client

A Phish.net API client, with support for parsing the 'setlistdata' field. Inspired by the other Ruby Phish.net API [client](http://api.phish.net/wrappers/ruby.php) written by [Stephen Blackstone](http://phish.net/user/steveb3210).

[rdoc](http://rubydoc.info/github/alexebird/phish_dot_net_client/master/frames/file/README.md)


## Install

Gemfile:

    gem 'phish_dot_net_client'

Rubygems:

    gem install phish_dot_net_client


## Usage

    # Setup frequently used parameters
    PhishDotNetClient.apikey = 'private-api-key'
    PhishDotNetClient.authorize 'fluffhead', 'passwurd'
    PhishDotNetClient.clear_auth  # clears the stored apikey, username, and authkey

    # Call API methods by replacing '.' with '_' in the method name
    PhishDotNetClient.pnet_shows_setlists_latest

    # The 'pnet_' prefix is optional
    PhishDotNetClient.shows_setlists_latest

    # Pass arguments to the API call with a hash
    PhishDotNetClient.shows_setlists_get :showdate => '2013-07-31'
    PhishDotNetClient.shows_query :month => '7', :country => 'USA', :state => 'CA'

    # Arguments are not checked for validity before being passed
    PhishDotNetClient.shows_setlists_get :fluff => 'head'  # returns {"success" => 0,"reason" => "General API Error"}

    # All methods return JSON parsed into Ruby Hashes/Arrays
    tweez = PhishDotNetClient.shows_setlists_get :showdate => '2013-07-31'
    # => [
    #      {
    #        "showdate" => "2013-07-31",
    #            "city" => "Stateline",
    #           "state" => "NV",
    #     "setlistdata" => #<PhishDotNetClient::Setlist ...>

See [Phish.net API docs](http://api.phish.net/docu/) for available API methods.


### setlistdata Parsing

JSON objects that have a "setlistdata" will have that field parsed and replaced with
a [Setlist](http://rubydoc.info/github/alexebird/phish_dot_net_client/master/PhishDotNetClient/Setlist) object. See rdoc for how to use the parsed setlist.


## Known Issues

- Song titles with a ',' character don't get parsed correctly due to the ',' being interpreted as a boundary between song titles. See lib/phish_dot_net_client/setlist.rb#133 for the regex and parsing code.



## Testing

To run specs:

    bundle exec rake spec

Pull requests are welcome!

