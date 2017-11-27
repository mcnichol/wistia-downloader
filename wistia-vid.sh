#!/usr/bin/env bash

set -e

SCRIPT_DIR=${BASH_SOURCE%/*}
WISTIA_BASE_URL="https://fast.wistia.net/embed/iframe/"

#VIDEO_ID=$(curl -s https://javaspecialists.teachable.com/courses/214654/lectures/3684467 | grep -oe "data-wistia-id=\'[0-9a-zA-Z]*\'" | awk -F "'" '{print $2}')
VIDEO_ID=$1
VIDEO_URL="$WISTIA_BASE_URL/$VIDEO_ID"

JSON_RESPONSE=$(curl -s ${VIDEO_URL} | grep -e "Wistia.iframeInit*" | grep -oe "{.*}}")
echo "JSON RESPONSE PARSED"

VIDEO_NAME=$(echo $JSON_RESPONSE | jq -r '.name')
VIDEO_URL=$(echo $JSON_RESPONSE | jq -r '.assets[0].url')
if [ ! -d "$SCRIPT_DIR/videos" ]; then
   echo "Creating Directory for Videos"
   mkdir videos
   echo '{"videos": []}' > "$SCRIPT_DIR/videos/history.json"
fi

echo "Downloading File $VIDEO_NAME"
curl --progress-bar -o "$SCRIPT_DIR/videos/$VIDEO_NAME" $VIDEO_URL

printf "Saving Record to History\nID:\t$VIDEO_ID\nNAME:\t$VIDEO_NAME\nURL:\t$VIDEO_URL\n"

cat $SCRIPT_DIR/videos/history.json | jq --arg u $VIDEO_URL --arg n "$VIDEO_NAME" --arg i $VIDEO_ID '.videos += [{"id": $i, "name": $n, "url": $u}]' > $SCRIPT_DIR/videos/tmp.json
mv $SCRIPT_DIR/videos/tmp.json $SCRIPT_DIR/videos/history.json
