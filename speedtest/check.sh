#!/usr/bin/env sh

alias speedtest='$HOME/.pyenv/shims/speedtest'

LOG_DIRECTORY="$1"
LOG_FILE="$LOG_DIRECTORY"/"$(date --iso-8601=seconds)".log
mkdir -p "$LOG_DIRECTORY"
touch "$LOG_FILE"

OUTPUT_DIRECTORY="$2"
OUTPUT_FILE="$OUTPUT_DIRECTORY"/"$(date --iso-8601=seconds)".csv
mkdir -p "$OUTPUT_DIRECTORY"
touch "$OUTPUT_FILE"

# ERROR CODES
ERR_NO_SPEEDTEST=1

if ! command -v speedtest >/dev/null 2>&1; then
  echo "Speedtest CLI not found. Aborting!" >> "$LOG_FILE"
  printf "PATH:\t%s" "$PATH" >> "$LOG_FILE"
  exit $ERR_NO_SPEEDTEST
fi

echo "server_id,server_name,location,time,distance_km,latency_ms,download_bits,upload_bits,unknown_9,client_ip" >> "$OUTPUT_FILE"

oldIFS=$IFS
IFS="
"

for i in $(speedtest --list | head -n 6 | tail -n 5 | cut -d ')' -f 1); do
  speedtest --csv --server "$i" >> "$OUTPUT_FILE"	
done
IFS=$oldIFS
