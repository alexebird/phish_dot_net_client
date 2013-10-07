require 'rspec/core/rake_task'


desc "Parse the documentation from Phish.net to get the current method calls"
task :parse_method_docs do
  require 'nokogiri'
  require 'open-uri'
  require 'pp'

  doc_url = "http://api.phish.net/docu/navigation.php"
  methods = {}

  longest_method_name = 0
  doc = Nokogiri::HTML(open(doc_url))
  doc.css("#static-list li.sub span").each_slice(2) do |method,scope|
    method = method.content

    if method.size > longest_method_name
      longest_method_name = method.size
    end

    methods[method] = { :scope => scope.content }
  end

  puts "{"
  methods.keys.sort.each_with_index do |method,i|
    comma = (i+1) == methods.size ? "" : ","
    puts %[  %-#{longest_method_name + 3}s => { :scope => %s }%s] %
      ['"' + method.to_s + '"', '"' + methods[method][:scope] + '"', comma]
  end
  puts "}"
end


desc "Default: run specs. Set COVERAGE=true before any spec-related task to generate code coverage."
task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "./spec/**/*_spec.rb"
  # t.verbose = false
end

desc "Run specs in spec/units"
RSpec::Core::RakeTask.new('spec:units') do |t|
  t.pattern = "./spec/units/**/*_spec.rb"
end

desc "Run specs in spec/integration"
RSpec::Core::RakeTask.new('spec:integration') do |t|
  t.pattern = "./spec/integration/**/*_spec.rb"
end

desc "Generate documentation"
task :doc do
  require 'yard'
  sh "yard"
end
