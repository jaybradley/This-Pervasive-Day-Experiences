require 'tweetstream'
require 'active_record'
require 'sqlite3'

# set up the database
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'twitter_daemon_for_pervasive_puffersphere.sqlite3.db'
)

ActiveRecord::Schema.define do
    create_table :tweets do |table|
        table.column :latitude, :float
        table.column :longitude, :float
        table.column :time, :time
    end
end

class Tweet < ActiveRecord::Base
end

# The third argument is an optional process name.
TweetStream::Daemon.new('jaybradley_dev','.thispervasiveday','twitter_tracker').sample do |status|
  #p status
  if status.geo != nil
    #puts "GEO"
    new_tweet = Tweet.new("time" => status.created_at, "latitude" => status.geo[:coordinates][0], "longitude" => status.geo[:coordinates][1])
    new_tweet.save
    p status.geo
    #p status.geo[:type]
    #p status.geo[:coordinates][0]
    #p status.geo[:coordinates][1]
    #p status.created_at
    #puts
    
    
  elsif status.place != nil
    #puts "PLACE"
    p status.place
#    p status.place[:bounding_box]
#    p status.place[:bounding_box][:type]
#    p status.place[:bounding_box][:coordinates][0]
#    p status.place[:bounding_box][:coordinates][0][0] # use this as the coordinate for plotting or take the center
#    p status.place[:bounding_box][:coordinates][0][0][0]
#    p status.place[:bounding_box][:coordinates][0][0][1]
#    p status.created_at
    #puts
    new_tweet = Tweet.new("time" => status.created_at, "latitude" => status.place[:bounding_box][:coordinates][0][0][0], "longitude" => status.place[:bounding_box][:coordinates][0][0][1])
    new_tweet.save
  elsif status.coordinates != nil
    puts "COORDINATES"
    p status.coordinates
    #p "COORDINATES [#{status.user.screen_name}] #{status.coordinates.class} #{status.coordinates} #{status.coordinates.type}"
    puts
  end
  
  # don't check location because it's user defined and could be anything. Maybe iPhones use this though for the GPS reading  
  #puts "[#{status.user.screen_name}] #{status.user.location}" if status.user.location != nil
  
  # Can start a festival server with:
  # festival_server
  # and use it like this:
  # echo "A test" | festival_client --ttw | paplay
  # could then stream the audio to the web-page
   
  #if(status.user[:lang] = "en") and (not status.text.include?("\\"))
  #  p to_ascii_iconv(status.text)
  #  system('echo "' + status.text + '" | festival_client --ttw | paplay')
  #end
end


