#require 'flickraw'
require 'flickraw-cached'

# Flickr API key applies to the application called "This Pervasive Day" on Jay Bradley's flickr account
FlickRaw.api_key="7c10f814aa40acc3482c8e3eb51aaa16"
FlickRaw.shared_secret="c7fb1c04d893a03c"

#1291083200
latest_time_of_events_retrieved = 1291723476

# Dates for flickr should look like this 2004-11-29 16:01:26
# More info at http://www.flickr.com/services/api/misc.dates.html

# Note that sorting using :sort => 'date-posted-asc' doesn't appear to work so I've sorted them myself
#sorted_photos = flickr.photos.search(:min_upload_date => "2010-10-10 10:10:10", :has_geo => true, :per_page => 5, :extras => "date_upload, geo").to_a.sort! { |a,b| a.dateupload <=> b.dateupload }
sorted_photos = flickr.photos.search(:has_geo => true, :per_page => 500, :extras => "date_upload, geo").to_a

sorted_photos = sorted_photos.delete_if {|event| event.dateupload.to_i <= latest_time_of_events_retrieved}   #=> ["a"]

sorted_photos.sort! { |a,b| a.dateupload <=> b.dateupload }



if(sorted_photos.length > 0) 
    #p sorted_photos
    #p sorted_photos[0].latitude
    #p sorted_photos[0].longitude
    #p f.class
    #p sorted_photos

    # TODO add a last taken date so that we don't get old photos we've already plotted. Get the date from the last entry in the database
    #flickr.photos.search(:has_geo => true, :sort => 'date-posted-asc', :per_page => 10).each do |photo|
    sorted_photos.each do |photo|
        #info = flickr.photos.getInfo(:photo_id => photo.id)
        #p info

        #geo = flickr.photos.geo.getLocation(:photo_id => photo.id).location
        
        #puts "Title is #{photo.title}, Latitude is #{photo.latitude.to_s}, Longitude is #{photo.longitude.to_s} posted at #{Time.at(photo.dateupload.to_i)} with URL #{FlickRaw.url(photo)}"
        puts "Posted at #{Time.at(photo.dateupload.to_i)}, that's #{photo.dateupload}"
      
    end
    p sorted_photos.length
    
else
    p "No photos uploaded"         
end
