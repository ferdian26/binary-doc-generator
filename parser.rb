require_relative 'fetcher'
require 'vcr'
require 'rest_client'
require 'readability'
require 'sanitize'


module BinaryDocs
  class Parser

    def initialize
      setup_vcr
      get_urls
    end

    def get_content
      url = rand(@urls.count)
      VCR.use_cassette(url) do
        content = Sanitize.clean(Readability::Document.new(RestClient.get(@urls[url])).content)
        puts content
      end
    end
    
    private
    
    def setup_vcr
      VCR.configure do |c|
        c.cassette_library_dir = 'vcr_cassettes'
        c.hook_into :webmock
      end
    end

    def get_urls
      VCR.use_cassette('wikipedia_featured_articles') do
        @urls = BinaryDocs::Fetcher.new.payload
      end
    end
  end
end

#content = BinaryDocs::Parser.new
#content.get_content
