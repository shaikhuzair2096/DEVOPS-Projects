#!/bin/bash

# If argument passed → use it
if [ -n "$1" ]; then
    dir="$1"
else
    read -p "enter the path to file: " dir
fi

if [ ! -d "$dir" ]; then
    echo "$dir path does not exist"
    exit 1
else
    echo "scanning logs for last 2 days"

    errors=$(find "$dir" -type f -name "*.log" -mtime -2 \
    -exec grep -H -i "ERROR" {} + 2>/dev/null)

    count=$(echo "$errors" | wc -l)

    if [ "$count" -gt 0 ]; then
        echo "Errors found: $count"

        echo -e "Found $count errors\n\nSample:\n$(echo "$errors" | head -5)" \
        | mail -s "Log Alert" your@email.com
    else
        echo "No errors found"
    fi
fi
