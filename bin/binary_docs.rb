#!/usr/bin/env ruby
require_relative '../lib/generator'
require_relative '../lib/parser'
require 'prawn'
require 'ruby-progressbar'

#PDFs
#12,000 files
#80 > 25Mb
#200 between 10-25
#400 between 5-10
#10k < 5

document = BinaryDocs::Generator.new
document.file_type = "TXT"
document.final_dir = "/Volumes/FreeAgent GoFlex Drive/txt"
number_of_documents = 10000
file_list = Dir.glob("cache/txt/*")
progress_bar = ProgressBar.create(:total => number_of_documents, :format => '%a |%b %i| %p%% Completed')

number_of_documents.times do
  container = ""
  size = (rand(0.1..4.8) * 1048576)
  while container.length < size 
    container << File.read(file_list[rand(file_list.count-1)])
  end
  document.new_content = container
  document.generate!
  progress_bar.increment
end
