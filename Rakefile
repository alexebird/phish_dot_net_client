require 'rspec/core/rake_task'

desc "Parse the documentation from Phish.net to get the current method calls"
task :parse_method_docs do
  # require 'nokogiri'
  require 'open-uri'

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

desc "Generate documentation"
task :doc do
  require 'yard'
  sh "yard"
end

desc "Instructions for releasing a new version"
task :"release:instructions" do
  version = PhishDotNetClient::VERSION
  gem_name = File.basename Dir.glob(File.join(File.expand_path('../', __FILE__), '*.gemspec')).first.sub('.gemspec', '')
  last_release = `git tag | grep --color=never "v[0-9]\." | sort | tail -n1`.strip

  if last_release == "v#{version}"
    puts
    puts "WARNING: tag of last release '#{last_release}' matches current version '#{version}'"
    puts
  elsif last_release.strip.empty?
    puts
    puts "There is no last release...is that correct?"
    puts
  end

  puts "1. update version.rb"
  puts "2. update History.md"
  puts "       git log #{last_release}..HEAD --no-merges --format=%B"
  puts "3. git commit -am 'v#{version}'; git tag v#{version}; git push origin v#{version}"
  puts "4. gem build #{gem_name}.gemspec ; mv #{gem_name}-#{version}.gem ~/gems/"
  puts "5. gem push ~/gems/#{gem_name}-#{version}.gem"
end
