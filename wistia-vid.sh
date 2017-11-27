#!/usr/bin/env bash

set -e

SCRIPT_DIR=${BASH_SOURCE%/*}
WISTIA_BASE_URL="https://fast.wistia.net/embed/iframe/"

source $SCRIPT_DIR/bin/config/functions.sh
source $SCRIPT_DIR/bin/config/styles.sh
source $SCRIPT_DIR/guard_clause.sh
source $SCRIPT_DIR/audit.sh

VIDEO_ID=$1
VIDEO_URL="$WISTIA_BASE_URL/$VIDEO_ID"

JSON_RESPONSE=$(curl -s ${VIDEO_URL} | grep -e "Wistia.iframeInit*" | grep -oe "{.*}}")
echo "JSON RESPONSE PARSED"

VIDEO_NAME=$(echo $JSON_RESPONSE | jq -r '.name' | sed 's/\"//g')
VIDEO_URL=$(echo $JSON_RESPONSE | jq -r '.assets[0].url' | sed 's/\"//g')

if [ ! -d "$SCRIPT_DIR/videos" ]; then
   echo "Creating Directory for Videos"
   mkdir videos
   audit_generate_history_file $SCRIPT_DIR
fi

echo "Downloading File $VIDEO_NAME"
curl --progress-bar -o "$SCRIPT_DIR/videos/$VIDEO_NAME" $VIDEO_URL

audit_create_record "${VIDEO_URL}" "${VIDEO_NAME}" "${VIDEO_ID}" "${SCRIPT_DIR}"
