#!/bin/bash

# Set default target directory and action
TARGET_DIR="."
ACTION=""

# Ask user for action
read -p "Enter the path to scan for duplicates: " TARGET_DIR
read -p "Choose action for duplicates: [d]elete, [m]ove, or [n]one: " ACTION
if [[ "$ACTION" == "m" ]]; then
  read -p "Enter directory to move duplicates to: " MOVE_DIR
  mkdir -p "$MOVE_DIR"
fi

declare -A file_hashes
declare -A duplicates

echo "Scanning files..."

# Loop through all files recursively
while IFS= read -r -d '' file; do
  if [[ -f "$file" ]]; then
    hash=$(md5sum "$file" | awk '{ print $1 }')
    if [[ -n "${file_hashes[$hash]}" ]]; then
      # Record duplicate
      duplicates["$file"]="${file_hashes[$hash]}"
    else
      file_hashes["$hash"]="$file"
    fi
  fi
done < <(find "$TARGET_DIR" -type f -print0)

# Output and handle duplicates
echo
echo "=== Duplicate Files Found ==="
for dup in "${!duplicates[@]}"; do
  original="${duplicates[$dup]}"
  echo "Duplicate: $dup"
  echo "Original : $original"

  case "$ACTION" in
  d)
    rm -i "$dup"
    ;;
  m)
    mv -i "$dup" "$MOVE_DIR/"
    ;;
  n | *) ;;
  esac
  echo
done

echo "Done."
