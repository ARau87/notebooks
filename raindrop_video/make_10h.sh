#!/usr/bin/env bash
# Builds a long video by repeating a seamless loop clip.
# Usage: ./make_10h.sh [loop=alpine_hut_rain_loop.mp4] [hours=10] [output=<loop>_<hours>h.mp4]
#   ./make_10h.sh                                   # 10 h of the alpine hut window
#   ./make_10h.sh raindrop_loop.mp4 1               # 1 h of the raindrop loop
# Video is stream-copied (no re-encode, takes minutes); the audio is re-encoded so the loop seams stay click-free.
# Output size is roughly 4-7 GB per hour (about 45-70 GB for 10 hours).
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
LOOP="${1:-alpine_hut_rain_loop.mp4}"
[[ -f "$LOOP" ]] || LOOP="$DIR/$LOOP"
HOURS="${2:-10}"
OUT="${3:-$(basename "${LOOP%.mp4}")_${HOURS}h.mp4}"
SECONDS_TOTAL=$(awk "BEGIN{print int($HOURS*3600)}")
ffmpeg -hide_banner -y -stream_loop -1 -i "$LOOP" -t "$SECONDS_TOTAL" \
  -map 0:v -map 0:a -c:v copy -c:a aac -b:a 192k -movflags +faststart "$OUT"
