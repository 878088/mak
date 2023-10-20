#!/bin/bash

# Get the HTML content of the page
html_content=$(curl -s "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git")

# Extract the branch names from the HTML content
branch_names=$(echo "$html_content" | grep -oP "refs/heads/linux-\d+\.\d+\.y" | grep -oP "linux-\d+\.\d+\.y")

# Sort the branch names and get the latest one
latest_branch=$(echo "$branch_names" | sort -Vr | head -n 1)

# Print the latest branch name
echo "$latest_branch"
