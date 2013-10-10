# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'phish_dot_net_client/version'

Gem::Specification.new do |spec|
  spec.name        = 'phish_dot_net_client'
  spec.version     = PhishDotNetClient::VERSION
  spec.date        = Date.today.to_s
  spec.licenses    = ['MIT']
  spec.authors     = ["Alexander Bird"]
  spec.email       = ["alexebird@gmail.com"]
  spec.homepage    = "https://github.com/alexebird/phish_dot_net_client"
  spec.summary     = %q{Phish.net API client with setlist parsing}
  spec.description = %q{Calls any Phish.net API method. Supports authentication. Parses 'setlistdata' fields.}

  spec.required_ruby_version     = '>= 1.9.1'
  spec.required_rubygems_version = '>= 1.3.6'

  spec.add_dependency 'rest-client', '~> 1.6.7'
  spec.add_dependency 'json', '~> 1.8.0'
  spec.add_dependency 'nokogiri', '~> 1.6.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'yard', '~> 0.8'

  spec.files       = `git ls-files`.split($/)
  spec.test_files  = spec.files.grep(%r{^spec/})

  spec.require_paths = ["lib"]
end
