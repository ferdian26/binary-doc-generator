require "bundler"
Bundler.setup
require "docx_templater"

data = {
        :teacher => "Priya Vora",
        :building => "Building #14",
        :classroom => :'Rm 202',
        :district => "Washington County Public Schools",
        :senority => 12.25,
        :roster => [
            {:name => 'Sally', :age => 12, :attendence => '100%'},
            {:name => :Xiao, :age => 10, :attendence => '94%'},
            {:name => 'Bryan', :age => 13, :attendence => '100%'},
            {:name => 'Larry', :age => 11, :attendence => '90%'},
            {:name => 'Kumar', :age => 12, :attendence => '76%'},
            {:name => 'Amber', :age => 11, :attendence => '100%'},
            {:name => 'Isaiah', :age => 12, :attendence => '89%'},
            {:name => 'Omar', :age => 12, :attendence => '99%'},
            {:name => 'Xi', :age => 11, :attendence => '20%'},
            {:name => 'Noushin', :age => 12, :attendence => '100%'}
        ],
        :event_reports => [
            {:name => 'Science Museum Field Trip', :notes => 'PTA sponsored event. Spoke to Astronaut with HAM radio.'},
            {:name => 'Wilderness Center Retreat', :notes => '2 days hiking for charity:water fundraiser, $10,200 raised.'}
        ],
        :created_at => "11-12-03 02:01"
       }
path = Dir.getwd
input_file = path+"/ExampleTemplate.docx"
output_file = path+"/Output.docx"
DocxTemplater::DocxCreator.new(input_file, data).generate_docx_file(output_file)
