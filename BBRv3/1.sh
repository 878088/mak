#!/bin/bash

URL="https://mirrors.edge.kernel.org/debian/pool/main/l/linux/"

wget -qO- $URL | 
grep -Po '(?<=href=")[^"]*(?=")' | 
grep "linux-image-6.7-cloud.*unsigned" |
sed "s|^|$URL|"
