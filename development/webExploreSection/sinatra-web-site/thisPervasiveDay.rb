require 'sinatra'
require 'erb'
require 'active_record'
require 'json'
#require 'sqlite3'
require 'dm-core'
require 'dm-migrations'
require 'dm-aggregates'

# set up the database
#ActiveRecord::Base.establish_connection(
#  :adapter => 'sqlite3',
#  :database =>  'interactive_documentary.sqlite3.db'
#)

DataMapper.setup(:default, 'mysql://thisPervasiveDay:inspace@localhost/ThisPervasiveDay-iDoc')

#ActiveRecord::Schema.define do
#    create_table :first_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#        table.column :one, :decimal
#        table.column :two, :decimal
#        table.column :three, :decimal
#        table.column :four, :decimal
#        table.column :five, :decimal
#        table.column :six, :decimal
#        table.column :seven, :decimal
#        table.column :eight, :decimal
#    end
#    create_table :first_video_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#    end
#    create_table :second_video_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#    end
#    create_table :third_video_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#    end
#    create_table :fourth_video_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#    end
#    create_table :fith_video_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#    end

#end

#class FirstQuestionAnswer < ActiveRecord::Base
#end

#class FirstVideoQuestionAnswer < ActiveRecord::Base
#end

#class ThirdVideoQuestionAnswer < ActiveRecord::Base
#end

#class FourthVideoQuestionAnswer < ActiveRecord::Base
#end

#class FithVideoQuestionAnswer < ActiveRecord::Base
#end

#class SixthVideoQuestionAnswer < ActiveRecord::Base
#end

#create_table :fith_video_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#    end

class FirstQuestionAnswer
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :time, Time
  property :answer, String
end

class FirstVideoQuestionAnswer
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :time, Time
  property :answer, String
end

class ThirdVideoQuestionAnswer
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :time, Time
  property :answer, String
end

class FourthVideoQuestionAnswer
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :time, Time
  property :answer, String, :length => 1000
  property :one, Float
  property :two, Float
  property :three, Float
  property :four, Float
  property :five, Float
  property :six, Float
  property :seven, Float
  property :eight, Float
  property :nine, Float
  property :ten, Float
end

class FifthVideoQuestionAnswer
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :time, Time
  property :answer, String, :length => 1000
  property :one, String
  property :two, String
  property :three, String
  property :four, String
end

class SixthVideoQuestionAnswer
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :time, Time
  property :answer, String
end

class SeventhVideoQuestionAnswer
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :time, Time
  property :answer, String
end

class EighthVideoQuestionAnswer
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :time, Time
  property :answer, String
end

class NinthVideoQuestionAnswer
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :time, Time
  property :answer, String
end

DataMapper.finalize

#DataMapper.auto_migrate! # wipes clean the database
DataMapper.auto_upgrade! # does not wipe the database clean

videos = ["first", "third", "fourth", "fifth", "sixth", "seventh"]

get '/' do
    #@video_filenames = ["test1", "test2", "test3"]
    erb :index
    #"This Pervasive Day Interactive Documentary"
end

get '/next_video' do

    # if no more videos then show the charts page
    #puts "next_video params[:current_video_index].to_i = " + params[:current_video_index] + " and videos.length = " + videos.length.to_s
    if params[:current_video_index].to_i >= videos.length
        puts "end of videos"
        
    end

    puts "Loading video: " + videos[params[:current_video_index].to_i] + " at index " + params[:current_video_index]
    @video_filename = videos[params[:current_video_index].to_i]
    puts "/next_video for video: " + @video_filename + " with index " + params[:current_video_index].to_s
    erb :video
end

get '/next_question' do

    @video_filename = videos[params[:current_video_index].to_i]
    
    puts "/next_question for video: " + @video_filename + " with index " + params[:current_video_index].to_s
    if @video_filename == videos.last
        @last_video = true
        puts "Last video"
        
    else
        @last_video = false
        puts "Not last video"
    end
    erb :question
end

get '/first_question' do
    
    puts "First question"
    @video_filename = "firstQuestion"
    erb :question
end


post '/answer' do
    # Open up the table for the question and write the answer to it. Maybe add such things as submission time and date
    case params[:question]
    
        when 'firstQuestion':
            FirstQuestionAnswer.create("time" => Time.now, "answer" => params[:answer])
        
        when 'first':
            #puts 'Received an answer: ' + params[:question] + ', ' + params[:answer]
            FirstVideoQuestionAnswer.create("time" => Time.now, "answer" => params[:answer])
        
        when 'third':
            ThirdVideoQuestionAnswer.create("time" => Time.now, "answer" => params[:answer])
        
        when 'fourth':
            preferences = JSON.parse(params[:answer])
            puts 'Fourth question answer: ' + params[:question] + ', ' + params[:answer].to_s + ", " + preferences["0"].to_s + "..."
            FourthVideoQuestionAnswer.create("time" => Time.now, "answer" => params[:answer], "one" => preferences["0"], "two" => preferences["1"], "three" => preferences["2"], "four" => preferences["3"], "five" => preferences["4"], "six" => preferences["5"], "seven" => preferences["6"], "eight" => preferences["7"])
        
        when 'fifth':
            selectedness = JSON.parse(params[:answer])
            puts 'Fifth question answer: ' + params[:question] + ', ' + params[:answer].to_s + ", " + selectedness["0"].to_s + "..."
            FifthVideoQuestionAnswer.create("time" => Time.now, "answer" => params[:answer], "one" => selectedness["0"], "two" => selectedness["1"], "three" => selectedness["2"], "four" => selectedness["3"])
        
        when 'sixth':
            SixthVideoQuestionAnswer.create("time" => Time.now, "answer" => params[:answer])
        
            
    end
   
end

get '/redirect_to_charts' do
  #redirect 'http://ww.google.co.uk'
  #redirect '/charts'
  erb :test_charts
end

get '/charts' do
    erb :test_charts
end

get '/charts/:chart_name' do
    # * matches anything
    puts "Chart name is: " + params[:chart_name]
    
    case params[:chart_name]
    
        when 'firstQuestion':
            # work out the stats from the database
            answers = FirstQuestionAnswer.all()
            num_heaven_answers = answers.select{|a| a.answer == "Heaven" }.size
            @heaven_percentage = ((num_heaven_answers.to_f / answers.size.to_f) * 100)
            @heaven_percentage = format("%0.1f", @heaven_percentage).to_f # to one decimal place
            @hell_percentage = 100 - @heaven_percentage
    
        when 'firstVideoQuestion':
            # work out the stats from the database
            answers = FirstVideoQuestionAnswer.all()
            num_heaven_answers = answers.select{|a| a.answer == "Yes" }.size
            @heaven_percentage = ((num_heaven_answers.to_f / answers.size.to_f) * 100)
            @heaven_percentage = format("%0.1f", @heaven_percentage).to_f # to one decimal place
            @hell_percentage = 100 - @heaven_percentage
            
        when 'thirdVideoQuestion':
            # work out the stats from the database
            answers = ThirdVideoQuestionAnswer.all()
            num_yes_answers = answers.select{|a| a.answer == "Yes" }.size
            @yes_percentage = ((num_yes_answers.to_f / answers.size.to_f) * 100)
            @yes_percentage = format("%0.1f", @yes_percentage).to_f # to one decimal place
            @no_percentage = 100 - @yes_percentage
            
        when 'fourthVideoQuestion':
            # there's no test4 video yet so no test4 answers yet so just make them up and show a different type of graph
            
            #avaeragForOne = 0
            #FirstQuestionAnswer.all.each do | answer |
            #  averageForOne += answer.one
            #end
            #averageForOne = (FirstQuestionAnswer.avg(:one) * 100)
            
            @data = "[{ y: #{FourthVideoQuestionAnswer.avg(:one) * 100}, marker: { symbol: 'url(graphics/shopping.png)' } }, { y: #{FourthVideoQuestionAnswer.avg(:two) * 100}, marker: { symbol: 'url(graphics/childcare.png)' } }, { y: #{FourthVideoQuestionAnswer.avg(:three) * 100}, marker: { symbol: 'url(graphics/games.png)' } }, { y: #{FourthVideoQuestionAnswer.avg(:four) * 100}, marker: { symbol: 'url(graphics/home.png)' } }, { y: #{FourthVideoQuestionAnswer.avg(:five) * 100}, marker: { symbol: 'url(graphics/padlock.png)' } }, { y: #{FourthVideoQuestionAnswer.avg(:six) * 100}, marker: { symbol: 'url(graphics/car.png)' } }, {y: #{FourthVideoQuestionAnswer.avg(:seven) * 100}, marker: { symbol: 'url(graphics/elderlyCare.png)' } }, {y: #{FourthVideoQuestionAnswer.avg(:eight) * 100}, marker: { symbol: 'url(graphics/emergency.png)' } }]"
            
            
        when 'fifthVideoQuestion':
            # work out the stats from the database
            
            selecteds = Hash.new
            
            selecteds['one'] = FifthVideoQuestionAnswer.count(:one => "selected")
            selecteds['two'] = FifthVideoQuestionAnswer.count(:two => "selected")
            selecteds['three'] = FifthVideoQuestionAnswer.count(:three => "selected")
            selecteds['four'] = FifthVideoQuestionAnswer.count(:four => "selected")
            
            puts "selecteds: " + selecteds.to_s
            
            choices = ['one', 'two', 'three', 'four']
            
            puts "choices: " + choices.to_s
            
            #choices.sort_by! {| obj | selecteds[obj] }
            #choices.sort! {|x,y| x[1] <=> y[1]}
            choices.sort!{|a,b| selecteds[b] <=> selecteds[a]}
            
            puts "choices: " + choices.to_s
            
            
            texts = Hash.new
            texts['one'] = "Some loss of\\nprivacy is worth it\\nfor a safer world"
            texts['two'] = "We should be more\\ncareful about giving out\\n our information"
            texts['three'] = "I'm concerned about\\nhow computers could\\nuse data about me"
            texts['four'] = "I don't reall worry\\nabout technological privacy\\nor security"
            
            @oneText = texts[choices[0]]
            @twoText = texts[choices[1]]
            @threeText = texts[choices[2]]
            @fourText = texts[choices[3]]
            
        
        when 'sixthVideoQuestion':
            # work out the stats from the database
            answers = SixthVideoQuestionAnswer.all()
            num_heaven_answers = answers.select{|a| a.answer == "Heaven" }.size
            @heaven_percentage = ((num_heaven_answers.to_f / answers.size.to_f) * 100)
            @heaven_percentage = format("%0.1f", @heaven_percentage).to_f # to one decimal place
            @hell_percentage = 100 - @heaven_percentage

            @yes_percentage = 5
            @no_percentage = 95
            
    end
    
    erb ("charts/" + params[:chart_name]).to_sym
    
    
end

post '/fictional_identity' do
    puts "Posted new fictional identity: " + params.keys.to_s
    STDERR.puts "Uploading file, original name #{params[:title]}"
    
    filename = params[:title] + "." + params[:ext]
    tmpfile = params[:data][:tempfile]
    
    STDERR.puts "params[:data] is " + params[:data].to_s
    
    directory = "public/fictional_identity_images"
    path = File.join(directory, filename)
    file = File.open(path, "wb") 
    #{ |f| f.write(tmpfile.read) }
    
    while block = tmpfile.read(65536)
    #  # here you would write it to its final location
    #  STDERR.puts block.inspect
      file.write(block)
    end
    "Upload complete"
end

get '/fictional_identity' do
  Dir.entries("./public/fictional_identity_images/").each do | image |
    puts image if image.end_with?(".jpg")
  end
  "Done"
end


# for ogv video
# ffmpeg2theora --videoquality 5 --audioquality 1 --max_size 320x240 input_filename.extension

# for webm video (2 passes) input file is pr6.dv
# 1st pass
#ffmpeg -pass 1 -passlogfile pr6.dv -threads 16 -keyint_min 0 -g 250 -skip_threshold 0 -qmin 1 -qmax 51 -i pr6.dv -vcodec libvpx -b 614400 -s 320x240 -aspect 4:3 -an -y pr6.dv
# 2nd pass
#ffmpeg -pass 2 -passlogfile pr6.dv -threads 16 -keyint_min 0 -g 250 -skip_threshold 0 -qmin 1 -qmax 51 -i pr6.dv -vcodec libvpx -b 614400 -s 320x240 -aspect 4:3 -acodec libvorbis -y pr6.webm
