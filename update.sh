#!/bin/bash
set -euo pipefail

echo "************** $(date) [docker-update-all]"

BASE_DIR="/srv/data"   # change if needed
DOCKER_BIN="docker"

for dir in "$BASE_DIR"/*; do
    if [ -d "$dir" ] && [ -f "$dir/docker-compose.yml" ]; then
        cd "$dir"
        echo "Processing $dir..."

        running_services=$($DOCKER_BIN compose ps --services --filter "status=running" || true)

        echo "Running services before update:"
        echo "$running_services"

        echo "Pulling latest images in $dir..."
        $DOCKER_BIN compose pull

        if [ -n "$running_services" ]; then
            echo "Restarting previously running services in $dir..."
            $DOCKER_BIN compose up -d $running_services
        else
            echo "No services were running in $dir before update. Skipping up."
        fi

        echo "Done with $dir."
        echo "----------------------------------------"
    fi
done

echo "Pruning dangling images..."
$DOCKER_BIN image prune -f

echo "All done at $(date)"

