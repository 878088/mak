#!/bin/bash
content=$(curl -s "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git")
branch=$(echo "$content" | grep -oP "linux-\d+\.\d+\.y")
latest_branch=$(echo "$branch" | sort -Vr | head -n 1)
echo "$branch_names"