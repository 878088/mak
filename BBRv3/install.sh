API="https://api.github.com/repos/878088/BBRv3/releases"
response=$(curl -s "$API")
download_url=$(echo "$response" | jq -r '.[].assets[] | select(.browser_download_url | contains("linux-headers") or contains("linux-image") or contains("linux-libc-dev")) | .browser_download_url')
arch=$(dpkg --print-architecture)
if [ "$arch" == "amd64" ]; then
    download_url=$(echo "$download_url" | grep "amd64")
elif [ "$arch" == "arm64" ]; then
    download_url=$(echo "$download_url" | grep "arm64")
else
    echo "Unsupported architecture: $arch"
    exit 1
fi
echo "Downloading from: $download_url"
wget "$download_url"
