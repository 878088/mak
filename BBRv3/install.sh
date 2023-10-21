API="https://api.github.com/repos/878088/BBRv3/releases"
urls=$(curl -s "$API" | jq -r '.[].assets[].browser_download_url')
arch=$(dpkg --print-architecture)
if [ "$arch" == "amd64" ]; then
    download_url=$(echo "$urls" | grep "amd64")
elif [ "$arch" == "arm64" ]; then
    download_url=$(echo "$urls" | grep "arm64")
else
    echo "Unsupported architecture: $arch"
    exit 1
fi
echo "Downloading from: $download_url"
curl -O "$download_url"
