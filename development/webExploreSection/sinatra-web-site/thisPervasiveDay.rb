require 'sinatra'
require 'erb'
require 'active_record'
require 'sqlite3'

# set up the database
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'interactive_documentary.sqlite3.db'
)

#ActiveRecord::Schema.define do
#    create_table :test1_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#    end
#    create_table :test2_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#    end
#    create_table :test3_question_answers do |table|
#        table.column :time, :time
#        table.column :answer, :string
#    end
#end


class Test1QuestionAnswer < ActiveRecord::Base
end

class Test2QuestionAnswer < ActiveRecord::Base
end

class Test3QuestionAnswer < ActiveRecord::Base
end

videos = ["test1", "test2", "test3"]

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
        redirect '/charts'
    end

    puts "Loading video: " + videos[params[:current_video_index].to_i] + " at index " + params[:current_video_index]
    @video_filename = videos[params[:current_video_index].to_i]
    erb :video
end

get '/next_question' do
    @video_filename = videos[params[:current_video_index].to_i]
    
    puts "Question for video: " + @video_filename + " with index " + params[:current_video_index].to_s
    if @video_filename == videos.last
        @last_video = true
        puts "Last video"
    else
        @last_video = false
        puts "Not last video"
    end
    erb :question
end

post '/answer' do
    # Open up the table for the question and write the answer to it. Maybe add such things as submission time and date
    case params[:question]
        when 'test1':
            #puts 'Received an answer: ' + params[:question] + ', ' + params[:answer]
            new_answer = Test1QuestionAnswer.new("time" => Time.now, "answer" => params[:answer])
        when 'test2':
            new_answer = Test2QuestionAnswer.new("time" => Time.now, "answer" => params[:answer])
        when 'test3':
            new_answer = Test3QuestionAnswer.new("time" => Time.now, "answer" => params[:answer])
    end
    new_answer.save
end

get '/charts' do
    erb :test_charts
end

get '/charts/:chart_name' do
    # * matches anything
    puts "Chart name is: " + params[:chart_name]
    
    case params[:chart_name]
        when 'test1':
            # work out the stats from the database
            answers = Test1QuestionAnswer.all()
            num_heaven_answers = answers.select{|a| a.answer == "Heaven" }.size
            @heaven_percentage = ((num_heaven_answers.to_f / answers.size.to_f) * 100)
            @heaven_percentage = format("%0.1f", @heaven_percentage).to_f # to one decimal place
            @hell_percentage = 100 - @heaven_percentage
        when 'test2':
            # work out the stats from the database
            answers = Test2QuestionAnswer.all()
            num_heaven_answers = answers.select{|a| a.answer == "Heaven" }.size
            @heaven_percentage = ((num_heaven_answers.to_f / answers.size.to_f) * 100)
            @heaven_percentage = format("%0.1f", @heaven_percentage).to_f # to one decimal place
            @hell_percentage = 100 - @heaven_percentage

            @yes_percentage = 5
            @no_percentage = 95
            
        when 'test3':
            # work out the stats from the database
            answers = Test3QuestionAnswer.all()
            num_yes_answers = answers.select{|a| a.answer == "Yes" }.size
            @yes_percentage = ((num_yes_answers.to_f / answers.size.to_f) * 100)
            @yes_percentage = format("%0.1f", @yes_percentage).to_f # to one decimal place
            @no_percentage = 100 - @yes_percentage
        when 'test4':
            # there's no test4 video yet so no test4 answers yet so just make them up and show a different type of graph
            @dave_data = "[1.0, 1.9, 1.5, -1.5, -1.2, -1.5, -1.2, -1.5, 1.3, 1.3, 1.9, 1.6]"
            @bob_data = "[-2.2, -2.8, -2.7, 2.3, 2.0, 2.0, 2.8, 2.1, 2.1, 2.1, 2.6, 2.5]"
            @chris_data = "[-0.9, 0.6, 3.5, 8.4, 13.5, -17.0, -18.6, -17.9, -14.3, -9.0, 3.9, 1.0]"
            @sarah_data = "[3.9, 4.2, 5.7, -8.5, -11.9, -15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]"
            
    end
    
    erb ("charts/" + params[:chart_name]).to_sym
    
    
end

# for ogv video
# ffmpeg2theora --videoquality 5 --audioquality 1 --max_size 320x240 input_filename.extension

# for webm video (2 passes) input file is pr6.dv
# 1st pass
#ffmpeg -pass 1 -passlogfile pr6.dv -threads 16 -keyint_min 0 -g 250 -skip_threshold 0 -qmin 1 -qmax 51 -i pr6.dv -vcodec libvpx -b 614400 -s 320x240 -aspect 4:3 -an -y pr6.dv
# 2nd pass
#ffmpeg -pass 2 -passlogfile pr6.dv -threads 16 -keyint_min 0 -g 250 -skip_threshold 0 -qmin 1 -qmax 51 -i pr6.dv -vcodec libvpx -b 614400 -s 320x240 -aspect 4:3 -acodec libvorbis -y pr6.webm
