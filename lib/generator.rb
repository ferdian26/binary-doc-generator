require 'fileutils'

module BinaryDocs
  class Generator
    attr_accessor :file_type, :new_content
    attr_reader :file_name, :temp_dir, :final_dir

    def make_dirs 
      make_temp_dir
      make_payload_dir
    end

    def set_unique_file_name
      @file_name = "#{Time.now.strftime("%m%d%y_%H%M%S")}"
    end

    def extract_file
      file_type.nil? ? warn_and_exit : system("unzip -qq template.#{file_type} -d #{temp_dir}")
    end

    def modify_file_contents
      if new_content.nil? 
        warn_and_exit
      else
        original_text = File.read(get_file_to_edit)
        new_text = original_text.gsub(/MAGICAL_STRING_TO_REPLACE/, "#{new_content}")
        File.open(get_file_to_edit, "w") {|file| file << new_text}
      end
    end

    def compress_file
      Dir.chdir(temp_dir)
      system("zip -qqr #{file_name}.#{file_type} *")
      FileUtils.move "#{file_name}.#{file_type}", "../#{final_dir}/"
      Dir.chdir("..")
    end

    def cleanup
      FileUtils.rm_rf(Dir.glob("#{temp_dir}/*"))
    end
    
    def generate!
      case file_type.upcase
        when "TXT"
          make_payload_dir
          set_unique_file_name
          create_with_content
        when "PDF"
          make_dirs
          set_unique_file_name
          create_with_content
          cleanup
        when "DOCX", "XLSX", "PPTX"
          make_dirs
          set_unique_file_name
          extract_file
          modify_file_contents
          compress_file
          cleanup
        else
          puts "No file type specified"
      end
    end


    private

    def create_with_content
      case file_type.upcase
        when "TXT"
          File.open("#{final_dir}/#{file_name}.txt", "w") { |file| file << new_content }
        when "PDF"
          require 'prawn'
          Prawn::Document.generate("#{final_dir}/#{file_name}.pdf") do |pdf|
#            puts "[#{Time.now}] Generating PDF with #{new_content.length} characters..."
            pdf.text new_content
          end 
        else
          puts "No relevant file type found"
      end
    end

    def make_temp_dir
      @temp_dir = "tmp"
      if Dir.glob("*").include?(temp_dir)
        FileUtils.rm_rf(Dir.glob("#{temp_dir}/*"))
      else
        Dir.mkdir(temp_dir)
      end
    end

    def make_payload_dir
      @final_dir = "payload"
      if Dir.glob("*").include?(final_dir)
        return
      else
        Dir.mkdir(final_dir)
      end
    end

    def warn_and_exit
      warn "Please provide a file type."
      exit
    end

    def get_file_to_edit
      case file_type
        when "docx"
          return temp_dir+"/word/document.xml"
        when "pptx"
          return temp_dir+"/slides/slide1.xml"
        when "xlsx"
          return temp_dir+"/xl/sharedStrings.xml"
        else
          warn_and_exit
      end
    end
  end
end

#generator = BinaryDocs::Generator.new
#generator.file_type = "pdf"
#generator.new_content = 'Hello World!'
#generator.generate!
#`open .`
