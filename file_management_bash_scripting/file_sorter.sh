#!/bin/bash

# Script to organize files and folders based on types

# create directories that does not exist
if [[ ! -d Documents ]]; then
  mkdir Documents
fi

if [[ ! -d Images ]]; then
  mkdir Images
fi

if [[ ! -d Videos ]]; then
  mkdir Videos
fi

if [[ ! -d Audio ]]; then
  mkdir Audio
fi

if [[ ! -d Archives ]]; then
  mkdir Archives
fi

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
  *)
  vip | tar)
    echo moving file to Archives
    mv $filename Archives/
    ;;
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
