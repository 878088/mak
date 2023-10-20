#!/bin/bash
html_content=$(curl -s "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git")

branch_names=$(echo "$html_content" | grep -oP 'option value="linux-\d+\.\d+\.y"' | grep -oP 'linux-\d+\.\d+\.y')

latest_branch=$(echo "$branch_names" | sort -Vr | head -n 1)

echo "$latest_branch"