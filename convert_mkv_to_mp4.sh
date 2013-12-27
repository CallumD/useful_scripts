#!/bin/bash
#
# converts an MKV file to PS3 format
#
# Requires avconv and HandbrakeCLI
#
# This script will attempt to convert a file with avconv (fast)
# and will fallback to Handbrake to encode more difficult files
# when encountering an error.
#
IFS=$(echo -en "\n\b")

# Log start time
START_TIME=$(date +%s)

function mkvextensions() {
  #filter out files that don't have mkv extensions and produce a list of files extension free
  if [ "${1:(-4)}" = ".mkv" ]; then
    filenamePath="${1:0:(-4)}"
  else
    filenamePath=''
  fi
}

function removePath() {
  filenameOnly="${1##*/}"
}

for filename in `find`
do
  mkvextensions $filename
  if [ "$filenamePath" != "" ]; then
    removePath $filenamePath
    echo "--- [$filenamePath.mkv] ---"
    avconv -i "$filenamePath.mkv" -c:v copy -c:a ac3_fixed -b:a 448k "$filenamePath.mp4"
    if [ "$?" != "0" ]; then
      echo "!!! Encode failed $filenamePath.mp4 !!!"
      rm $filenamePath.mp4
    else
      rm $filenamePath.mkv
    fi
  fi
done

#log end time
END_TIME=$(date +%s)
echo "Conversion time: $(( $END_TIME - $START_TIME )) seconds"
