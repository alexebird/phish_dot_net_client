task :parse_method_docs do
  require 'nokogiri'
  require 'open-uri'
  require 'pp'

  doc_url = "http://api.phish.net/docu/navigation.php"

  doc = Nokogiri::HTML(open(doc_url))
  # doc.css("ul#static-list li.sub span").each{|x| puts x.content}# ul#static-list li.sub span").size#.each_slice(2).map do |method,scope|
  methods = doc.css("#static-list li.sub span").each_slice(2).map do |method,scope|
    { :method => method.content, :scope => scope.content }
  end

  pp methods
end
