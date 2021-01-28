#!/bin/bash

echo 'Enter the URL: '
read url
youtube-dl -f best "$url"

date=`date +%Y-%m-%d.%H:%M:%S`
for f in *.mp4; do
    
    duration=$(ffmpeg -i "$f" 2>&1 | grep "Duration"| cut -d " " -f 3,4)  #Video duration
    length=$(echo "$duration" | awk '{ split($2, X, ":"); print 3600*X[1] + 60*X[2] + X[3] }' )  #convert video duration to seconds
    echo "$duration"
    echo "$length"
    read -p 'Start time trim:' trim_start
    read -p 'End time trim:' trim_end
    start_length=$(echo "$trim_start" | awk '{ split($1, X, ":"); print 3600*X[1] + 60*X[2] + X[3] }' )   #convert start trim duration to seconds
    end_length=$(echo "$trim_end" | awk '{ split($1, X, ":"); print 3600*X[1] + 60*X[2] + X[3] }' )       #convert end trim duration to seconds
    echo "$start_length"
    echo "$end_length"
    if (($start_length > $length)) || (($end_length > $length)) ; then
      echo "Video başlangıcını veya bitişini büyük seçtiniz! Video süresi: $duration"
      break

    fi
    ffmpeg -i "$f" -ss "$trim_start" -to "$trim_end" -c copy "${f%.mp4}_$date-trimmed.mp4"  #video trim 
    ffmpeg -i "$f" "${f%.mp4}_$date-gif.gif"  #convert video to gif
done







