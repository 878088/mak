#!/bin/bash

URL="https://mirrors.edge.kernel.org/debian/pool/main/l/linux/"

wget -qO- $URL | 
grep -Po '(?<=href=")[^"]*(?=")' | 
grep "linux-image\|cloud" |
sed "s|^|$URL|"
