API="https://api.github.com/repos/878088/BBRv3/releases"
response=$(curl -s "$API")
download_urls=$(echo "$response" | jq -r '.[].assets[] | select(.browser_download_url | contains("linux-headers") or contains("linux-image") or contains("linux-libc-dev")) | .browser_download_url')
arch=$(dpkg --print-architecture)
if [ "$arch" == "amd64" ]; then
    download_urls=$(echo "$download_urls" | grep "amd64")
elif [ "$arch" == "arm64" ]; then
    download_urls=$(echo "$download_urls" | grep "arm64")
else
    echo "Unsupported architecture: $arch"
    exit 1
fi
mkdir -p BBRv3
while read -r url; do
    wget -q "$url" -P BBRv3
done <<< "$download_urls"
