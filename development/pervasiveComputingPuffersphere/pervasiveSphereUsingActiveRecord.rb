require 'sinatra'
#require 'flickraw'
require 'flickraw-cached'
require 'json'
require 'active_record'
require 'sqlite3'

enable :sessions

# Flickr API key applies to the application called "This Pervasive Day" on Jay Bradley's flickr account
FlickRaw.api_key="7c10f814aa40acc3482c8e3eb51aaa16"
FlickRaw.shared_secret="c7fb1c04d893a03c"

# Dates for flickr should look like this 2004-11-29 16:01:26
# More info at http://www.flickr.com/services/api/misc.dates.html
initial_latest_time_of_events_retrieved = "0"

# connect to the database
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'twitter_daemon_for_pervasive_puffersphere.sqlite3.db'
)

# define our rows in the database
class Tweet < ActiveRecord::Base
end

get '/' do
    session["latest_time_of_events_retrieved"] = initial_latest_time_of_events_retrieved
    #p "Initial #{session["latest_time_of_events_retrieved"]} time is #{Time.at(session["latest_time_of_events_retrieved"].to_i)}"
    erb :index
end

get '/get_twitter_events' do
    content_type :json
    events = []
    
    # username jaybradley_dev
    # password .thispervasiveday
    
    # get every row in the table and delete them
    tweets = Tweet.all()
    Tweet.delete_all()
    # turn the rows into json and return
    p tweets
    
    tweets.each do |tweet|
       p tweet
       events.push({:date_posted => tweet.time, :location => {:latitude => tweet.latitude, :longitude => tweet.longitude}})
    end
    
    events.to_json
end

# TODO remove the use of title as probably wont use it
get '/get_flickr_events' do
    content_type :json
    events = []

    # flickr photos come in batches as it's the upload time we're looking at
    
    #COULD: store a log and replay them to show accelerated activity and show real-time info over the top less frequently
    # TODO Add tweets from twitter
    
    #sorted_photos = flickr.photos.search(:min_upload_date => session["latest_time_of_events_retrieved"], :has_geo => true, :per_page => 500, :extras => "date_upload, geo").to_a.sort! { |a,b| a.dateupload <=> b.dateupload }

    sorted_photos = flickr.photos.search(:has_geo => true, :per_page => 500, :extras => "date_upload, geo").to_a
    sorted_photos = (sorted_photos.delete_if {|a| ((a.dateupload.to_i) <= (session["latest_time_of_events_retrieved"].to_i))})
    sorted_photos.sort! { |a,b| a.dateupload <=> b.dateupload }
    
    if not sorted_photos.empty?
        session["latest_time_of_events_retrieved"] = sorted_photos[-1].dateupload
        puts
        #p "Setting last date to #{session["latest_time_of_events_retrieved"].to_i} time is #{Time.at(session["latest_time_of_events_retrieved"].to_i)}"
        puts
    end
    
    #p "Up to time #{Time.at(session["latest_time_of_events_retrieved"].to_i)} with #{sorted_photos.length} new entries"
    
    sorted_photos.each do |photo|
        
        #puts "Title is #{photo.title}, Latitude is #{photo.latitude.to_s}, Longitude is #{photo.longitude.to_s} posted at #{photo.dateupload} with URL #{FlickRaw.url(photo)}"
        # dates.posted is a unix timestamp i.e. number of seconds
        events.push({:title => photo.title, :date_posted => photo.dateupload, :location => {:latitude => photo.latitude, :longitude => photo.longitude}, :time => photo.dateupload})
    end
    
    
    #{:id => 1, :foo => 'bar'}.to_json
    #{:title => info.title, :location => {:latitude => geo.latitude, :longitude => geo.longitude}, :URL => FlickRaw.url_s(info)}.to_json
    events.to_json
end


#public function equirectangular_position(lat:Number, lng:Number):Point{
#  var newX:Number = ((lng + 180) * (map_width  / 360));
#  var newY:Number = (((lat * -1) + 90) * (map_height  / 180));
#           
#  return new Point(newX,newY);
#}

