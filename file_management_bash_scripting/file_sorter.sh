#!/bin/bash

# Script to organize files and folders based on types

# Check if the user provided a directory
if [[ -n "$1" ]]; then
  target_dir="$1"
else
  target_dir="." # Default to current directory
fi

# Check if target_dir exists and is a directory
if [[ ! -d "$target_dir" ]]; then
  echo "Error: '$target_dir' is not a valid directory."
  exit 1
fi

# Change to the target directory
cd "$target_dir" || exit

# create directories that does not exist
for directory in Documents Images Videos Audio Archives; do
  [[ ! -d $directory ]] && mkdir $directory
done

# function to sort file
sort_file() {
  filename=$1
  ext=${filename##*.}

  # check if the file extension is a video, doc or image
  case $ext in
  mp4 | mkv | mov | avi | wmv | flv | webm)
    echo moving file to Videos
    mv $filename Videos/
    ;;

  jpeg | png | gif | tiff | bmp | svg)
    echo moving file to Images
    mv $filename Images/
    ;;
  txt | doc | docx | csv | ini | log | rtf)
    echo moving file to Documents
    mv $filename Documents/
    ;;
  mp3)
    echo moving file to Audio
    mv $filename Audio/
    ;;
  zip | tar)
    echo moving file to Archives
    mv $filename Archives/
    ;;
  *)
    echo "can't tell type of file for: $filename"
    ;;
  esac

}

myscript=$0

for file in *; do
  # if current file is a regular file and is not equal to my script
  if [[ -f $file && $file != $myscript ]]; then
    sort_file $file
  fi

done
