require_relative 'spider'
require_relative 'generator'
require 'ruby-progressbar'
require 'vcr'
require 'rest_client'
require 'readability'
require 'sanitize'

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :webmock
  #c.allow_http_connections_when_no_cassette = true
end

VCR.use_cassette('wikipedia_featured_articles') do
  spider = Spider.new
  spider.get_links
  @urls = spider.payload
end

generator = BinaryDocGenerator.new
generator.file_type = "docx"
progress_bar = ProgressBar.create(:total => @urls.count, :format => '%a |%b %i| %p%% Completed')

@urls.each do |url|
  VCR.use_cassette(@urls.index(url)) do
    RestClient.get(url)
    #generator.new_content = Sanitize.clean(Readability::Document.new(RestClient.get(url)).content)
    #generator.generate!
  end
  progress_bar.increment
end
`open .`
