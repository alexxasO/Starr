#!/bin/bash

# Author: u/ProductRockstar
# https://www.reddit.com/r/jellyfin/comments/11dgmp3/script_to_add_language_overlay_to_movie_poster/

MOVIES_DIR="/home/alexis/Projects/Starr/volume/data/media/movies"
OVERLAY_DIR="/home/alexis/Projects/Starr/overlays"

while true
do
  cd "$MOVIES_DIR"
  for dir in */; do
    cd "$MOVIES_DIR/$dir"
    pwd

    flink=$(readlink -f folder.jpg)
    creatortool=$( exiftool -f -s3 -"creatortool" "$flink" )

    if [ "${creatortool}" != "993" ]; then
      echo "Processing $flink"
      mlink=$(readlink -f *.mkv)
      langs=$( ffprobe "$mlink" -show_entries stream=index:stream_tags=language -select_streams a -v 0 -of json=c=1 | jq --raw-output '.streams[].tags.language')

      ENG='eng'
      FRA='fre'
      GER='ger'
      DUT='dut'
      ITA='ita'
      SPA='spa'
      POR='por'
      RUS='rus'
      JPN='jpn'
      KOR='kor'

      echo "Languages: $langs"

      case $langs in

        *"$FRA"*)
          widthposter=$( exiftool -f -s3 -"ImageWidth" "$flink" )
	        convert "$OVERLAY_DIR/fra_overlay.png" -resize "$widthposter" "$OVERLAY_DIR/fra_overlay_tmp.png"
	        convert  "$flink"  "$OVERLAY_DIR/fra_overlay_tmp.png" -flatten  "$flink"
	        chmod +644 "$flink"
	        chown nobody "$flink"
	        exiftool -creatortool="993" -overwrite_original "$flink"
          echo "FRA overlay added for $flink"
          ;;

        *)
          echo "No overlay added for $flink"
          ;;
      esac

    fi
  done
  sleep 90000
done
