#!/bin/bash
API="https://api.github.com/repos/878088/BBRv3/releases"
urls=$(curl -s "$API" | jq -r '.[].assets[].browser_download_url')
for url in $urls; do
    filename=$(basename "$url")
    architecture=$(dpkg --print-architecture "$filename" 2>/dev/null)
    echo "File: $filename"
    echo "Architecture: $architecture"
    echo
done
