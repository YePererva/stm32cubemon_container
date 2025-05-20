#!/bin/bash

# Check if any stm32cubemon images exist
IMAGE_COUNT=$(podman images --filter reference=*stm32cubemon* -q | wc -l)

if [ "$IMAGE_COUNT" -eq 0 ]; then
    echo "No stm32cubemon images found. Nothing to clean up."
    exit 0
fi

IMAGE_ID=$(podman images --filter reference=*stm32cubemon* | awk 'NR>1 {print $3}')

# Get container IDs that are based on this image
CONTAINER_IDS=$(podman ps -a --filter ancestor="$IMAGE_ID" -q)

if [ -z "$CONTAINER_IDS" ]; then
    echo "No containers found running this image."
else
    echo "Found containers: $CONTAINER_IDS"
  
    for CONTAINER_ID in $CONTAINER_IDS; do
        podman stop -t 0 "$CONTAINER_ID"
        podman rm "$CONTAINER_ID"
    done
fi

podman rmi "$IMAGE_ID"