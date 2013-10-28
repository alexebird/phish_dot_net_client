if ENV["COV"]
  require 'simplecov'
  SimpleCov.start
end

require 'bundler'
Bundler.require :development

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'phish_dot_net_client'

RSpec.configure do |config|
end
