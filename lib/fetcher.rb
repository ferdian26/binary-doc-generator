require 'rest-client'
require 'nokogiri'
require 'vcr'

module BinaryDocs
  class Fetcher 
    attr_reader :payload, :starting_url

    def initialize
      @starting_url = 'http://en.wikipedia.org/wiki/Wikipedia:Featured_articles'
      @payload = []
      get_url_list
    end
  
    def get_url_list
      doc = Nokogiri::HTML(RestClient.get(starting_url))
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
