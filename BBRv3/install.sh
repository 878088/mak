API_URL="https://api.github.com/repos/878088/BBRv3/releases"
download_urls=$(curl -s "$API_URL" | jq -r '.[].assets[].browser_download_url')
for url in $download_urls; do
    echo "$url"
done
