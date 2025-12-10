#!/usr/bin/env bash

IPOD_MOUNT="${1:-/Volumes/IPOD}"
DEST_ROOT="${2:-$HOME/Desktop/iPod_Backup}"
IPOD_MUSIC_DIR="$IPOD_MOUNT/iPod_Control/Music"

if ! command -v exiftool >/dev/null 2>&1; then
  echo "exiftool missing" >&2
  echo "Install it with:  brew install exiftool"
  exit 1
fi

if [ ! -d "$IPOD_MUSIC_DIR" ]; then
  echo "No iPod music dir at: $IPOD_MUSIC_DIR" >&2
  echo "Make sure the iPod is in disk mode and mounted."
  exit 1
fi

mkdir -p "$DEST_ROOT" || exit 1

sanitize() {
  local s="$1"
  s="${s//\//-}"
  s="${s//:/-}"
  s="${s//\?/}"
  s="${s//\*/}"
  s="${s//</}"
  s="${s//>/}"
  s="${s//|/}"
  s="$(echo "$s" | tr -s ' ' | sed 's/^ *//;s/ *$//')"
  echo "$s"
}

echo "Source:      $IPOD_MUSIC_DIR"
echo "Destination: $DEST_ROOT"
echo "Scanning iPod files..."
echo

find "$IPOD_MUSIC_DIR" -type f \( -iname "*.mp3" -o -iname "*.m4a" -o -iname "*.m4p" -o -iname "*.aac" \) |
while IFS= read -r src; do
  artist=$(exiftool -s3 -Artist "$src" 2>/dev/null)
  album=$(exiftool -s3 -Album "$src" 2>/dev/null)
  title=$(exiftool -s3 -Title "$src" 2>/dev/null)
  track=$(exiftool -s3 -Track "$src" 2>/dev/null)

  if [ -z "$artist" ]; then artist="Unknown Artist"; fi
  if [ -z "$album" ]; then album="Unknown Album"; fi

  if [ -z "$title" ]; then
    base=$(basename "$src")
    title="${base%.*}"
  fi

  track_num=""
  if [ -n "$track" ]; then
    track_num=$(printf "%s" "$track" | awk -F'/' '{print $1}' | tr -cd '0-9')
  fi

  track_prefix=""
  if [ -n "$track_num" ]; then
    track_padded=$(printf "%02d" "$track_num")
    track_prefix="$track_padded - "
  fi

  ext="${src##*.}"
  ext=$(echo "$ext" | tr 'A-Z' 'a-z')

  safe_artist=$(sanitize "$artist")
  safe_album=$(sanitize "$album")
  safe_title=$(sanitize "$title")

  dest_dir="$DEST_ROOT/$safe_artist/$safe_album"
  mkdir -p "$dest_dir" || continue

  dest_file="$dest_dir/${track_prefix}${safe_title}.$ext"

  if [ -e "$dest_file" ]; then
    n=1
    while :; do
      candidate="$dest_dir/${track_prefix}${safe_title}_$n.$ext"
      [ ! -e "$candidate" ] && break
      n=$((n+1))
    done
    dest_file="$candidate"
  fi

  echo "Copying:"
  echo "  $src"
  echo "    -> $dest_file"
  cp -p "$src" "$dest_file"
  echo
done

echo "Done!"
echo "All tracks copied to: $DEST_ROOT"

