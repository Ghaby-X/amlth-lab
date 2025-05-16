#!/bin/bash

TARGET="."
MIN_SIZE=0
MAX_DEPTH=3
TOP_N=0

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

TARGET=$(realpath "$TARGET")

echo "Disk usage for: $TARGET (min size: ${MIN_SIZE}KB, max depth: $MAX_DEPTH)"
echo "-------------------------------------------------------------"

# Gather size and depth information
find "$TARGET" -mindepth 0 -maxdepth "$MAX_DEPTH" -print0 |
  while IFS= read -r -d '' item; do
    size=$(du -sk "$item" 2>/dev/null | cut -f1)
    if [[ "$size" -ge "$MIN_SIZE" ]]; then
      echo -e "$(realpath "$item")\t$size"
    fi
  done |
  sort |
  awk -v base="$TARGET" -v top_n="$TOP_N" '
  BEGIN {
    count = 0
  }
  {
    path = $1
    size = $2
    full[path] = size
    parts = split(path, tokens, "/")
    parent = ""
    for (i = 1; i < parts; i++) {
      parent = parent "/" tokens[i]
      if (!(parent in seen)) {
        seen[parent] = 1
        order[++n] = parent
      }
    }
    if (!(path in seen)) {
      seen[path] = 1
      order[++n] = path
    }
  }
  END {
    shown = 0
    for (i = 1; i <= n; i++) {
      path = order[i]
      size = full[path]
      if (size == "") size = 0
      depth = gsub("/", "/", path) - gsub("/", "/", base)
      if (depth < 0) depth = 0
      split(path, segs, "/")
      name = segs[length(segs)]
      if (path == base) name = segs[length(segs)]
      indent = ""
      for (j = 0; j < depth; j++) indent = indent "  "
      printf "%s- %s [%d KB]\n", indent, name, size
      shown++
      if (top_n > 0 && shown >= top_n) break
    }
  }'
