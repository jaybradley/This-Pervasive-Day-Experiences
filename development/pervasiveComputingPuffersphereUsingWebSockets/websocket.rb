require 'rubygems'
require 'eventmachine'
require 'em-websocket'
#require 'twitter_stream'
require 'tweet_collector'

TWITTER_USERNAME = 'jaybradley_dev'
TWITTER_PASSWORD = '.thispervasiveday'

EM.run {
  websocket_connections = []
  
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
  stream.ontweet { |tweet|
      #puts "New tweet: #{tweet}"
      
      websocket_connections.each do |socket|
        #socket.send(JSON.generate({
        #  :tweet => tweet
        #}))
        socket.send(tweet)
      end
  }
}
