require 'rest-client'
require 'nokogiri'
require 'vcr'

module BinaryDocs
  class Fetcher 
    attr_reader :payload

    def initialize
      @url = 'http://en.wikipedia.org/wiki/Wikipedia:Featured_articles'
      @payload = []
      get_urls
    end
  
    def get_urls
      doc = Nokogiri::HTML(RestClient.get(@url))
      doc.css('p a').each do |link|
        url = link['href']
        if url.include? "http://"
          return #skip
        end
        @payload << "http://en.wikipedia.org#{url}"
      end
    end
  end
end

#puts BinaryDocs::Fetcher.new.payload
