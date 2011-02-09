require 'tweetstream'
#require 'active_record'
#require 'sqlite3'
require 'placemaker'
require 'dm-core'
require  'dm-migrations'

# set up the database
#DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/twitter_daemon_for_pervasive_puffersphere.sqlite3.db")
#DataMapper.setup(:default, 'postgres://localhost/twitter_daemon_for_pervasive_puffersphere')
DataMapper.setup(:default, 'mysql://jay_dev:norealpassword@localhost/twitter_daemon_for_pervasive_puffersphere')


#ActiveRecord::Base.establish_connection(
#  :adapter => 'sqlite3',
#  :database =>  'twitter_daemon_for_pervasive_puffersphere.sqlite3.db'
#)

class Tweet
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :latitude, Float
  property :longitude, Float
  property :time, DateTime
end

DataMapper.finalize

DataMapper.auto_migrate! # wipes clean the database
# DataMapper.auto_upgrade! # does not wipe the database clean

# The third argument is an optional process name.
TweetStream::Daemon.new('jaybradley_dev','.thispervasiveday','twitter_tracker').sample do |status|
  #p status
  
  begin # begin the rescue in case of exceptions
      
      if status.geo != nil
        
        #new_tweet = Tweet.new("time" => status.created_at, "latitude" => status.geo[:coordinates][0], "longitude" => status.geo[:coordinates][1])
        #new_tweet.save
        Tweet.create(:latitude => status.geo[:coordinates][0], :longitude => status.geo[:coordinates][1], :time => status.created_at)
           
        puts "geo\n"
        
        
        
      elsif status.place != nil
        
        #new_tweet = Tweet.new("time" => status.created_at, "latitude" => status.place[:bounding_box][:coordinates][0][0][0], "longitude" => status.place[:bounding_box][:coordinates][0][0][1])
        #new_tweet = Tweet.new("time" => status.created_at, "latitude" => status.place[:bounding_box][:coordinates][0][0][1], "longitude" => status.place[:bounding_box][:coordinates][0][0][0]) # this one is swapped around i.e. the lat and long may be wrong!
        #new_tweet.save
        Tweet.create(:time => status.created_at, :latitude => status.place[:bounding_box][:coordinates][0][0][1], :longitude => status.place[:bounding_box][:coordinates][0][0][0])
        puts "place\n"
        
      elsif status.coordinates != nil
        #puts "COORDINATES\n"  
      
      elsif(status.user.location != nil and status.user.location != '')
        # ask yahoo placemaker where the tweet is from

        placemaker = Placemaker::Client.new(:appid => "55Zy4lHV34EctmKfgSWYC3ugpfiYsuPbMdvvUFASt9Clg5pF6NEz4hz.y_4Ry1eCTVE-", :document_content => status.user.location, :document_type => 'text/plain')
          placemaker.fetch!

        if(placemaker.documents[0].respond_to?("geographic_scope"))
            if(placemaker.documents[0].geographic_scope.respond_to?("centroid"))
                
                #new_tweet = Tweet.new("time" => status.created_at, "latitude" => placemaker.documents[0].geographic_scope.centroid.lat, "longitude" => placemaker.documents[0].geographic_scope.centroid.lng)
                #new_tweet.save
                
                Tweet.create(:time => status.created_at, :latitude => placemaker.documents[0].geographic_scope.centroid.lat, :longitude => placemaker.documents[0].geographic_scope.centroid.lng)
        
                puts "placemaker\n"
              
            end
          end 
      end

      # Can start a festival server with:
      # festival_server
      # and use it like this:
      # echo "A test" | festival_client --ttw | paplay
      # could then stream the audio to the web-page
       
      #if(status.user[:lang] = "en") and (not status.text.include?("\\"))
      #  p to_ascii_iconv(status.text)
      #  system('echo "' + status.text + '" | festival_client --ttw | paplay')
      #end
      
      rescue
        p "An exception was thrown: ignore it"
      end
end


