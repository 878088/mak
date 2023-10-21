url="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
html=$(curl -s "$url")
branches=$(echo "$html" | grep -oP '/pub/scm/linux/kernel/git/stable/linux.git/log/\?h=\K[^"]*' | grep -v 'linux-rolling-stable' | grep -v 'linux-rolling-lts')
latest_branch=$(echo "$branches" | sort -Vr | head -n 1)
echo "$latest_branch" | sed 's/></a>.*//'
