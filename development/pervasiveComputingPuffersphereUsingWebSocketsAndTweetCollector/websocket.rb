require 'rubygems'
require 'eventmachine'
require 'em-websocket'
#require 'twitter_stream'
require 'tweet_collectorOLD_USING_TweetStream'

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
  puts "HERE 1"
  stream.ontweet { |tweet|
      puts "New tweet at websocket.rb: #{tweet}"
      
      websocket_connections.each do |socket|
        puts "for each socket connection "
        #socket.send(JSON.generate({
        #  :tweet => tweet
        #}))
        socket.send(tweet)
      end
  }
}
