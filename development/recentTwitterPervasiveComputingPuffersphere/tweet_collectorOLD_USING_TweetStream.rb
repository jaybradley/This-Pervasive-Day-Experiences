require 'tweetstream'
require 'json'

class TweetCollector

    def initialize(username, password)
        @username, @password = username, password
        @callbacks = []
        @client = TweetStream::Client.new('jaybradley_dev','.thispervasiveday')
        @client.sample do |status|
        puts "New tweet"
        p status
        
        #begin # begin the rescue in case of exceptions
      
            if status.geo != nil
                #Tweet.create(:latitude => status.geo[:coordinates][0], :longitude => status.geo[:coordinates][1], :time => status.created_at)

                #{:date_posted => tweet.time, :location => {:latitude => tweet.latitude, :longitude => tweet.longitude}}.to_json
                @callbacks.each { |c| c.call({:date_posted => status.created_at, :location => {:latitude => status.geo[:coordinates][0], :longitude => status.geo[:coordinates][1]}}.to_json.to_s) }
                puts "geo\n"
                
            elsif status.place != nil

                #Tweet.create(:time => status.created_at, :latitude => status.place[:bounding_box][:coordinates][0][0][1], :longitude => status.place[:bounding_box][:coordinates][0][0][0])
                @callbacks.each { |c| c.call({:date_posted => status.created_at, :location => {:latitude => status.place[:bounding_box][:coordinates][0][0][1], :longitude => status.place[:bounding_box][:coordinates][0][0][0]}}.to_json.to_s) }
                
                puts "place\n"

            elsif status.coordinates != nil
                #puts "COORDINATES\n"  

            elsif(status.user.location != nil and status.user.location != '')
                # ask yahoo placemaker where the tweet is from

                placemaker = Placemaker::Client.new(:appid => "55Zy4lHV34EctmKfgSWYC3ugpfiYsuPbMdvvUFASt9Clg5pF6NEz4hz.y_4Ry1eCTVE-", :document_content => status.user.location, :document_type => 'text/plain')
                placemaker.fetch!

                if(placemaker.documents[0].respond_to?("geographic_scope"))
                    if(placemaker.documents[0].geographic_scope.respond_to?("centroid"))

                    #Tweet.create(:time => status.created_at, :latitude => placemaker.documents[0].geographic_scope.centroid.lat, :longitude => placemaker.documents[0].geographic_scope.centroid.lng)
                    @callbacks.each { |c| c.call({:date_posted => status.created_at, :location => {:latitude => placemaker.documents[0].geographic_scope.centroid.lat, :longitude => placemaker.documents[0].geographic_scope.centroid.lng}}.to_json.to_s) }


                    puts "placemaker\n"

                    end
                end 
            end

            #rescue
            #    p "An exception was thrown: ignore it"
            #    #@callbacks.each { |c| c.call("exception") }
            #    p status
            #end
        end # end of sample

    end
    
    def ontweet(&block)
        @callbacks << block
    end

    
end





#TweetStream::Client.new('jaybradley_dev','.thispervasiveday').sample do |status|
#  p status
#  
#  begin # begin the rescue in case of exceptions
#      
#      if status.geo != nil
#        
#        #Tweet.create(:latitude => status.geo[:coordinates][0], :longitude => status.geo[:coordinates][1], :time => status.created_at)
#        
#        #{:date_posted => tweet.time, :location => {:latitude => tweet.latitude, :longitude => tweet.longitude}}.to_json
#        puts "geo\n"
#        
#        
#        
#      elsif status.place != nil
#        
#        #Tweet.create(:time => status.created_at, :latitude => status.place[:bounding_box][:coordinates][0][0][1], :longitude => status.place[:bounding_box][:coordinates][0][0][0])
#        puts "place\n"
#        
#      elsif status.coordinates != nil
#        #puts "COORDINATES\n"  
#      
#      elsif(status.user.location != nil and status.user.location != '')
#        # ask yahoo placemaker where the tweet is from

#        placemaker = Placemaker::Client.new(:appid => "55Zy4lHV34EctmKfgSWYC3ugpfiYsuPbMdvvUFASt9Clg5pF6NEz4hz.y_4Ry1eCTVE-", :document_content => status.user.location, :document_type => 'text/plain')
#          placemaker.fetch!

#        if(placemaker.documents[0].respond_to?("geographic_scope"))
#            if(placemaker.documents[0].geographic_scope.respond_to?("centroid"))
#                
#                #Tweet.create(:time => status.created_at, :latitude => placemaker.documents[0].geographic_scope.centroid.lat, :longitude => placemaker.documents[0].geographic_scope.centroid.lng)
#        
#                puts "placemaker\n"
#              
#            end
#          end 
#      end

#      rescue
#        p "An exception was thrown: ignore it"

#      end
#end


