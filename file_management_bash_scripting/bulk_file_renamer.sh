#!/bin/bash

# Default values
PREFIX=""
SUFFIX=""
COUNTER=false
DATE_FLAG=false
DIRECTORY="."
REGEX_FIND=""
REGEX_REPLACE=""

# Parse command-line arguments
while getopts "p:s:d:ctr:f:r:" opt; do
  case $opt in
  p) PREFIX="$OPTARG" ;;
  s) SUFFIX="$OPTARG" ;;
  d) DIRECTORY="$OPTARG" ;;
  c) COUNTER=true ;;
  t) DATE_FLAG=true ;;
  r) REGEX_FIND="$OPTARG" ;;
  f) REGEX_REPLACE="$OPTARG" ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
  esac
done

# Get current date
DATE=$(date +%Y%m%d)

# Change to the specified directory
cd "$DIRECTORY" || {
  echo "Directory not found"
  exit 1
}

COUNT=1

for FILE in *; do
  # Skip if not a regular file
  [ -f "$FILE" ] || continue

  # Extract filename without extension and extension separately
  BASENAME="${FILE%.*}"
  EXT="${FILE##*.}"
  [ "$EXT" != "$FILE" ] && EXT=".$EXT" || EXT=""

  NEWNAME="$BASENAME"

  # Apply regex if provided
  if [[ -n "$REGEX_FIND" ]]; then
    NEWNAME=$(echo "$NEWNAME" | sed -E "s/$REGEX_FIND/$REGEX_REPLACE/")
  fi

  # Add prefix and suffix
  NEWNAME="${PREFIX}${NEWNAME}${SUFFIX}"

  # Add counter
  if $COUNTER; then
    NEWNAME="${NEWNAME}_$(printf "%03d" $COUNT)"
    ((COUNT++))
  fi

  # Add date
  if $DATE_FLAG; then
    NEWNAME="${NEWNAME}_${DATE}"
  fi

  NEWNAME="${NEWNAME}${EXT}"

  # Rename the file
  mv -i -- "$FILE" "$NEWNAME"
  echo "Renamed: $FILE -> $NEWNAME"
done
