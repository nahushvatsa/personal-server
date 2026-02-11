#!/bin/bash

# Loop through all directories in the current directory
for dir in */ ; do
    if [ -d "$dir" ]; then
        echo "Checking $dir"

        # Look for docker compose file
        if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
            echo "Found docker compose file in $dir"
            echo "Running docker compose up -d..."

            (
                cd "$dir" || exit
                docker compose up -d
            )

            echo "Done in $dir"
        else
            echo "No docker-compose file in $dir, skipping."
        fi

        echo ""
    fi
done

echo "All folders processed."

