require_relative 'fetcher'
require_relative 'generator'
require 'vcr'
require 'rest_client'
require 'readability'
require 'sanitize'


module BinaryDocs
  class Parser
    attr_reader :urls, :url

    def initialize
      setup_vcr
      get_url_list
    end

    def get_all_content
      generator = BinaryDocs::Generator.new
      generator.make_dirs
      urls.each_with_index do |url, index|
        File.open("payload/#{index}.txt", "w") { |file| file << use_cassette(url) { sanitize { url } } }
      end
    end

    def get_random_content
      url = rand(urls.count)
      use_cassette(url) { sanitize { urls[url] } }
    end
    
    private

    def use_cassette(input)
      VCR.use_cassette(input) do
        yield
      end
    end

    def sanitize
      Sanitize.clean(Readability::Document.new(RestClient.get(yield)).content)
    end
    
    def setup_vcr
      VCR.configure do |c|
        c.cassette_library_dir = 'vcr_cassettes'
        c.hook_into :webmock
      end
    end

    def get_url_list
      VCR.use_cassette('wikipedia_featured_articles') do
        @urls = BinaryDocs::Fetcher.new.payload
      end
    end
  end
end

#content = BinaryDocs::Parser.new
#content.get_random_content
#content.get_all_content
