#!/usr/bin/env bash

function audit_generate_history_file(){
   SCRIPT_DIR=${1}

   echo '{}' > "${SCRIPT_DIR}/videos/history.json"
}

function audit_create_record(){
   VIDEO_URL="$1"
   VIDEO_NAME="$2"
   VIDEO_ID="$3"
   SCRIPT_DIR="$4"

   msgWithColor "Saving record to history\n" ${GREEN}
   msgWithColor "ID:\t${VIDEO_ID}\n" ${GREEN}
   msgWithColor "Name:\t${VIDEO_NAME}\n" ${GREEN}
   msgWithColor "URL:\t${VIDEO_URL}\n" ${GREEN}

   record_as_json="{\"${VIDEO_ID}\":{\"file-name\":\"${VIDEO_NAME}\",\"url\":\"${VIDEO_URL}\"}}"

   cat "${SCRIPT_DIR}/videos/history.json" | jq --argjson r "${record_as_json}" '. += $r' > "${SCRIPT_DIR}/videos/tmp.json"

   mv "${SCRIPT_DIR}/videos/tmp.json" "${SCRIPT_DIR}/videos/history.json"

}
