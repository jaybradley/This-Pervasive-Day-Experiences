require 'sinatra'
require 'erb'

get '/' do
    @video_filename = "test"
    erb :index
    #"This Pervasive Day Interactive Documentary"
end


# for ogv video
# ffmpeg2theora --videoquality 5 --audioquality 1 --max_size 320x240 input_filename.extension

# for webm video (2 passes) input file is pr6.dv
# 1st pass
#ffmpeg -pass 1 -passlogfile pr6.dv -threads 16 -keyint_min 0 -g 250 -skip_threshold 0 -qmin 1 -qmax 51 -i pr6.dv -vcodec libvpx -b 614400 -s 320x240 -aspect 4:3 -an -y pr6.dv
# 2nd pass
#ffmpeg -pass 2 -passlogfile pr6.dv -threads 16 -keyint_min 0 -g 250 -skip_threshold 0 -qmin 1 -qmax 51 -i pr6.dv -vcodec libvpx -b 614400 -s 320x240 -aspect 4:3 -acodec libvorbis -y pr6.webm
