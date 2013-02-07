=begin
Some things to consider:
  multiple slides (for pptx) and rows/worksheets (for xlsx) to deal with
  small, medium, large templates
  3rd party data feed for dynamic text injection (e.g. rss news feed, downloaded mirror to pull from)
=end

require 'fileutils'

class BinaryDocGenerator
  attr_accessor :file_type, :new_content

  def initialize
    @temp_dir = "tmp" ; @final_dir = "finished_product"
    @file_name = "#{rand(9999999)}"
    make_dirs
  end

  def make_dirs 
    if Dir.glob("*").include?(@temp_dir)
      FileUtils.rm_rf(Dir.glob("#{@temp_dir}/*"))
    elsif Dir.glob("*").include?(@finished_product)
      return
    else
      Dir.mkdir(@temp_dir)
      Dir.mkdir(@final_dir)
    end
  end

  def extract_file
    @file_type.nil? ? warn_and_exit : system("unzip template.#{@file_type} -d #{@temp_dir}")
  end

  def modify_file_contents
    if @new_content.nil? 
      warn_and_exit
    else
      original_text = File.read(get_file_to_edit)
      new_text = original_text.gsub(/MAGICAL_STRING_TO_REPLACE/, "#{@new_content}")
      File.open(get_file_to_edit, "w") {|file| file << new_text}
    end
  end

  def compress_file
    Dir.chdir(@temp_dir)
    system("ls")
    system("zip -r #{@file_name}.#{@file_type} *")
    FileUtils.move "#{@file_name}.#{@file_type}", "../#{@final_dir}/"
    Dir.chdir("..")
  end

  def cleanup
    FileUtils.rm_rf(Dir.glob("#{@temp_dir}/*"))
  end
  
  def generate!
    extract_file
    modify_file_contents
    compress_file
    cleanup
  end

  private
  
  def warn_and_exit
    warn "Please provide a file type."
    exit
  end

  def get_file_to_edit
    case @file_type
      when "docx"
        return @temp_dir+"/word/document.xml"
      when "pptx"
        return @temp_dir+"/slides/slide1.xml"
      when "xlsx"
        return @temp_dir+"/xl/sharedStrings.xml"
      else
        puts "No supported filetype provided."
    end
  end

end

require 'vcr'
require 'rest_client'

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :webmock
end

urls = File.read("urls.list").split("\n")
urls.each do |url|
  VCR.use_cassette(urls.index(url)) do
    response = RestClient.get(url)
    puts response.body
  end
end

#generator = BinaryDocGenerator.new
#generator.file_type = "docx"
#generator.new_content = "HELLO WORLD!"
#generator.generate!

#generator.file_type = "xlsx"
#generator.generate!
