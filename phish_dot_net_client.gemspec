# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'date'
require 'phish_dot_net_client/version'

Gem::Specification.new do |spec|
  spec.name        = 'phish_dot_net_client'
  spec.version     = PhishDotNetClient::VERSION
  spec.date        = Date.today.to_s
  spec.licenses    = ['MIT']
  spec.authors     = ['Alexander Bird']
  spec.email       = ['alexebird@gmail.com']
  spec.homepage    = 'https://github.com/alexebird/phish_dot_net_client'
  spec.summary     = %q{Phish.net API client with setlist parsing}
  spec.description = %q{Calls any Phish.net API method. Supports authentication. Parses 'setlistdata' fields.}

  spec.required_ruby_version     = '>= 1.9.3'

  spec.add_runtime_dependency 'rest-client', '~> 1.6.7'
  spec.add_runtime_dependency 'oj', '~> 2.1.7'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'redcarpet', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.7.1'

  spec.files       = `git ls-files`.split($/)
  spec.test_files  = spec.files.grep(%r{^spec/})

  spec.require_paths = ['lib']
end
