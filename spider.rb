require 'rest-client'
require 'nokogiri'
require 'vcr'

class Spider
  attr_reader :payload

  def initialize
    @parent_url = 'http://en.wikipedia.org/wiki/Wikipedia:Featured_articles'
  end

  def get_links
    @payload = []
    doc = Nokogiri::HTML(RestClient.get(@parent_url))
    doc.css('p a').each do |link|
      url = link['href']
      if url.include? "http://"
        return #skip
      end
      @payload << "http://en.wikipedia.org#{url}"
    end
  end
end
