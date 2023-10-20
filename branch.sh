#!/bin/bash

url="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
html=$(curl -s $url)

branches=$(echo "$html" | grep -oP '/pub/scm/linux/kernel/git/stable/linux.git/log/\?h=\K[^"]*')

echo "$branches"
