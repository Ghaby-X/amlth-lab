#!/bin/bash

usage() {
  echo "Usage: $0 /path/to/dir1 /path/to/dir2"
  exit 1
}

# Ensure both directories exist
[ "$#" -ne 2 ] && usage

DIR1="$1"
DIR2="$2"

[ ! -d "$DIR1" ] && echo "Directory $DIR1 not found." && exit 1
[ ! -d "$DIR2" ] && echo "Directory $DIR2 not found." && exit 1

LOG=()

# Compare and sync files
sync_file() {
  local file_rel="$1"
  local file1="$DIR1/$file_rel"
  local file2="$DIR2/$file_rel"

  if [[ -f "$file1" && ! -f "$file2" ]]; then
    mkdir -p "$(dirname "$file2")"
    cp -p "$file1" "$file2"
    LOG+=("[Copied → $DIR2] $file_rel")
  elif [[ -f "$file2" && ! -f "$file1" ]]; then
    mkdir -p "$(dirname "$file1")"
    cp -p "$file2" "$file1"
    LOG+=("[Copied → $DIR1] $file_rel")
  elif [[ -f "$file1" && -f "$file2" ]]; then
    # Both exist, check for differences
    if ! cmp -s "$file1" "$file2"; then
      ts1=$(stat -c %Y "$file1")
      ts2=$(stat -c %Y "$file2")
      if [[ "$ts1" -gt "$ts2" ]]; then
        cp -p "$file1" "$file2"
        LOG+=("[Updated $DIR2] $file_rel")
      elif [[ "$ts2" -gt "$ts1" ]]; then
        cp -p "$file2" "$file1"
        LOG+=("[Updated $DIR1] $file_rel")
      else
        # Conflict: same timestamp, different content
        ts=$(date +"%Y%m%d%H%M%S")
        cp -p "$file1" "$file1.conflict.$ts.1"
        cp -p "$file2" "$file2.conflict.$ts.2"
        LOG+=("[Conflict] $file_rel → saved as conflict copies")
      fi
    else
      LOG+=("[Identical] $file_rel")
    fi
  fi
}

# Get list of all relative file paths in both directories
all_files=$( (cd "$DIR1" && find . -type f) && (cd "$DIR2" && find . -type f) | sort -u)

# Run sync logic
while IFS= read -r rel_file; do
  rel_file="${rel_file#./}" # Remove leading ./
  sync_file "$rel_file"
done <<<"$all_files"

# Show log
echo "Sync complete. Summary:"
for entry in "${LOG[@]}"; do
  echo "$entry"
done
