#!/usr/bin/env bash
# Builds a long video from the seamless 9.5 s raindrop loop.
# Usage: ./make_10h.sh [hours=10] [output=raindrop_10h.mp4]
# Video is stream-copied (no re-encode, takes minutes); the audio is re-encoded so the loop seams stay click-free.
# Output size is roughly 4.4 GB per hour (about 44 GB for 10 hours).
set -euo pipefail
HOURS="${1:-10}"
OUT="${2:-raindrop_10h.mp4}"
DIR="$(cd "$(dirname "$0")" && pwd)"
SECONDS_TOTAL=$(awk "BEGIN{print int($HOURS*3600)}")
ffmpeg -hide_banner -y -stream_loop -1 -i "$DIR/raindrop_loop.mp4" -t "$SECONDS_TOTAL" \
  -map 0:v -map 0:a -c:v copy -c:a aac -b:a 192k -movflags +faststart "$OUT"
