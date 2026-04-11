#!/bin/bash

set -e

TOKEN="YOUR_TOKEN"
OWNER="your-username"
REPO="your-repo"
BRANCH="release"

# Check if branch exists
response=$(curl -s -H "Authorization: Bearer $TOKEN" \
https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH)

exists=$(echo "$response" | jq -r '.name')

if [ "$exists" = "$BRANCH" ]; then
    echo "Branch already exists"
else
    echo "Branch does not exist, creating..."

    # Get master SHA
    master_sha=$(curl -s -H "Authorization: Bearer $TOKEN" \
    https://api.github.com/repos/$OWNER/$REPO/git/ref/heads/master \
    | jq -r '.object.sha')

    # Create branch
    curl -s -X POST -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    https://api.github.com/repos/$OWNER/$REPO/git/refs \
    -d "{
      \"ref\": \"refs/heads/$BRANCH\",
      \"sha\": \"$master_sha\"
    }"

    echo "Branch created"
fi
