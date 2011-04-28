require 'rubygems'
require 'eventmachine'
require 'em-websocket'
#require 'twitter_stream'
require 'tweet_collector'
require 'dm-core'

DataMapper.setup(:default, 'mysql://jay_dev:norealpassword@localhost/twitter_daemon_for_pervasive_puffersphere')

class Tweet
  include DataMapper::Resource
  property :id, Serial # An auto-increment integer key
  property :latitude, Float
  property :longitude, Float
  property :time, DateTime
end

TWITTER_USERNAME = 'jaybradley_dev'
TWITTER_PASSWORD = '.thispervasiveday'

EM.run {
  websocket_connections = []
  
  EventMachine.add_periodic_timer(1) {
    puts "Get random record"
    tweet = Tweet.get(1+rand(Tweet.count))
    puts tweet
    jsonString = {:date_posted => tweet.time, :location => {:latitude => tweet.latitude, :longitude => tweet.longitude}}.to_json
    
    puts jsonString
    websocket_connections.each do |socket|
      socket.send(jsonString)
    end
  }
  
  EM::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen {
      puts "Websocket connection opened"
      websocket_connections << ws
    }
    ws.onclose {
      puts "Websocket connection closed"
      websocket_connections.delete(ws)
    }
  end
  
  stream = TweetCollector.new(TWITTER_USERNAME, TWITTER_PASSWORD)
#  stream.ontweet { |tweet|
#      #puts "New tweet: #{tweet}"
#      
#      websocket_connections.each do |socket|
#        #socket.send(JSON.generate({
#        #  :tweet => tweet
#        #}))
#        socket.send(tweet)
#      end
#  }
}
