#!/bin/bash

# Default config
SOURCE=""
DEST=""
MODE="full"
LOGFILE=""
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
INCLUDE_FILE=""
EXCLUDE_FILE=""
ARCHIVE_NAME="backup_$TIMESTAMP.tar.gz"

# Help message
usage() {
  echo "Usage: $0 -s <source_dir> -d <destination_dir> [-m full|partial] [-i include_file] [-e exclude_file] [-l logfile]"
  exit 1
}

# Parse arguments
while getopts "s:d:m:i:e:l:" opt; do
  case $opt in
  s) SOURCE="$OPTARG" ;;
  d) DEST="$OPTARG" ;;
  m) MODE="$OPTARG" ;;
  i) INCLUDE_FILE="$OPTARG" ;;
  e) EXCLUDE_FILE="$OPTARG" ;;
  l) LOGFILE="$OPTARG" ;;
  *) usage ;;
  esac
done

# Check for required options
[[ -z "$SOURCE" || -z "$DEST" ]] && usage
[[ ! -d "$SOURCE" ]] && echo "Source directory does not exist." && exit 2
mkdir -p "$DEST"

log() {
  echo "$1"
  [[ -n "$LOGFILE" ]] && echo "$1" >>"$LOGFILE"
}

log "Starting backup: $MODE mode"

if [[ "$MODE" == "full" ]]; then
  log "Creating full backup of $SOURCE"
  tar -czf "$DEST/$ARCHIVE_NAME" -C "$SOURCE" .
elif [[ "$MODE" == "partial" ]]; then
  if [[ -n "$INCLUDE_FILE" ]]; then
    log "Creating partial backup (include list: $INCLUDE_FILE)"
    tar -czf "$DEST/$ARCHIVE_NAME" -C "$SOURCE" -T "$INCLUDE_FILE"
  elif [[ -n "$EXCLUDE_FILE" ]]; then
    log "Creating partial backup (excluding files from: $EXCLUDE_FILE)"
    tar -czf "$DEST/$ARCHIVE_NAME" -C "$SOURCE" --exclude-from="$EXCLUDE_FILE" .
  else
    log "Partial mode requires an include (-i) or exclude (-e) file."
    exit 3
  fi
else
  log "Invalid mode: $MODE. Use 'full' or 'partial'."
  exit 4
fi

log "Backup complete: $DEST/$ARCHIVE_NAME"
