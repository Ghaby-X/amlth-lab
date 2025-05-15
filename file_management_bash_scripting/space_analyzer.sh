#!/bin/bash

# Default values
TARGET="."
MIN_SIZE=0 # Minimum size in kilobytes
MAX_DEPTH=3
TOP_N=0 # Show top N largest entries (0 = all)

usage() {
  echo "Usage: $0 [-p path] [-m min_size_kb] [-d max_depth] [-t top_n]"
  exit 1
}

while getopts "p:m:d:t:" opt; do
  case $opt in
  p) TARGET="$OPTARG" ;;
  m) MIN_SIZE="$OPTARG" ;;
  d) MAX_DEPTH="$OPTARG" ;;
  t) TOP_N="$OPTARG" ;;
  *) usage ;;
  esac
done

# Convert max depth to actual number of slashes beyond base
BASE_DEPTH=$(echo "$TARGET" | awk -F"/" '{print NF}')
MAX_FIND_DEPTH=$((BASE_DEPTH + MAX_DEPTH))

echo "Disk usage for: $TARGET (min size: ${MIN_SIZE}KB, max depth: $MAX_DEPTH)"
echo "-------------------------------------------------------------"

# Find all files and directories, get sizes in KB
find "$TARGET" -mindepth 0 -maxdepth $MAX_DEPTH -print0 |
  while IFS= read -r -d '' item; do
    size=$(du -k "$item" 2>/dev/null | cut -f1)
    if [[ -n "$size" && "$size" -ge "$MIN_SIZE" ]]; then
      echo -e "$size\t$item"
    fi
  done |
  sort -nr |
  ([[ $TOP_N -gt 0 ]] && head -n "$TOP_N" || cat) |
  awk '
  {
    size = $1
    path = $2
    indent = gsub(/\//, "/", path) - 1
    if (indent > 0) indent--
    printf "%s%*s- %s [%d KB]\n", "", indent * 2, "", path, size
  }'
