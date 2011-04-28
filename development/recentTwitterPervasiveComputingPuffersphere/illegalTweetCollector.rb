require 'tweetstream'
require 'json'

require 'em-http'
require 'json'
require 'placemaker'

class IllegalTweetCollector

  URL = 'http://stream.twitter.com/1/statuses/sample.json'
  
  def initialize(username, password)
    @username, @password = username, password
    @callbacks = []
    @buffer = ""
    listen
  end
  
  def ontweet(&block)
    @callbacks << block
  end
  
  private
  
  def listen
    p "Connecting to twitter stream"
    http = EventMachine::HttpRequest.new(URL).post({
      :head => { 'Authorization' => [@username, @password] }
    })
    
    http.stream do |chunk|
      p "Recieved chunk"
      @buffer += chunk
      #process_buffer
      process_one_tweet_from_buffer
    end
  end
  
  def process_one_tweet_from_buffer
    #while line = @buffer.slice!(/.+\r\n/) # maybe this line is the culprit for bulk delivery of tweets. Try just taking one tweet at a time and sending it
    
    # take one tweet off the front of buffer
    line = @buffer.slice!(/.+\r\n/)
    
    if line != nil
    
      begin # watch out for JSON parsing exceptions

        # this next line sometimes throughs an exception when it fails to parse the tweet. It's quite rare so just ignore the exception but it needs to be caught, otherwise it crashes the process
        tweet = JSON.parse(line)
        geo_tweet = process_tweet(tweet)
        #p geo_tweet
        if geo_tweet != nil
          p geo_tweet
          @callbacks.each { |c| c.call(geo_tweet) }
        end

      rescue Exception
        puts "Exception in JSON parsing - ignoring it"
      end
      
    end

  end
  
  def process_buffer
    puts "process_buffer. buffer is: " + @buffer
    while line = @buffer.slice!(/.+\r\n/) # maybe this line is the culprit for bulk delivery of tweets. Try just taking one tweet at a time and sending it

      puts "line is: " + line

      tweet = JSON.parse(line)
 
      geo_tweet = process_tweet(tweet)

      #p geo_tweet

      if geo_tweet != nil
        p geo_tweet
        @callbacks.each { |c| c.call(geo_tweet) }
      end
    
    end
  end
  
  
  def process_tweet(tweet)
  
    #puts "\n\n"
    #p tweet.class
    #p tweet
    
    tweet_json = nil
    
#    begin
    
      if(tweet.has_key?('delete'))
            p "this is a delete - ignore it"
      elsif tweet['geo'] != nil
              #Tweet.create(:latitude => tweet.geo[:coordinates][0], :longitude => tweet.geo[:coordinates][1], :time => tweet.created_at)

              #{:date_posted => tweet.time, :location => {:latitude => tweet.latitude, :longitude => tweet.longitude}}.to_json
              tweet_json = {:date_posted => tweet['created_at'], :location => {:latitude => tweet['geo']['coordinates'][0], :longitude => tweet['geo']['coordinates'][1]}}.to_json
              puts "geo\n"
              
          elsif tweet['place'] != nil

              #Tweet.create(:time => tweet.created_at, :latitude => tweet.place[:bounding_box][:coordinates][0][0][1], :longitude => tweet.place[:bounding_box][:coordinates][0][0][0])
              tweet_json = {:date_posted => tweet['created_at'], :location => {:latitude => tweet['place']['bounding_box']['coordinates'][0][0][1], :longitude => tweet['place']['bounding_box']['coordinates'][0][0][0]}}.to_json
              
              puts "place\n"

          elsif tweet['coordinates'] != nil
              #puts "COORDINATES\n"  

          elsif(tweet['user']['location'] != nil and tweet['user']['location'] != '')
              # ask yahoo placemaker where the tweet is from

              placemaker = Placemaker::Client.new(:appid => "55Zy4lHV34EctmKfgSWYC3ugpfiYsuPbMdvvUFASt9Clg5pF6NEz4hz.y_4Ry1eCTVE-", :document_content => tweet['user']['location'], :document_type => 'text/plain')
              placemaker.fetch!

              if(placemaker.documents[0].respond_to?("geographic_scope"))
                  if(placemaker.documents[0].geographic_scope.respond_to?("centroid"))

                  #Tweet.create(:time => tweet.created_at, :latitude => placemaker.documents[0].geographic_scope.centroid.lat, :longitude => placemaker.documents[0].geographic_scope.centroid.lng)
                  tweet_json = {:date_posted => tweet['created_at'], :location => {:latitude => placemaker.documents[0].geographic_scope.centroid.lat, :longitude => placemaker.documents[0].geographic_scope.centroid.lng}}.to_json


                  puts "placemaker\n"

                  end
              end 
            
          end
#        rescue
#          p "An exception was thrown: ignore it"
#        end
        
        return tweet_json 
            
  end # end of process_tweet
  
end


