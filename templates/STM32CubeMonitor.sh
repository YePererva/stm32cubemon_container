#!/bin/bash

WORKDIR=$([ -z "$1" ] && echo `pwd` || echo "$1")

if [ ! -d ${WORKDIR} ]; then
    echo "$WORKDIR should be a directory"
    exit 1
fi

export GDK_BACKEND=x11

DISPLAY_ARGS="-e DISPLAY -e XAUTHORITY -v ${XAUTHORITY}:${XAUTHORITY}:rw -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
DBUS_ARGS="-v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:rw"

# Check if NVIDIA GPU is available
if command -v nvidia-smi &> /dev/null && nvidia-smi --query-gpu=name --format=csv,noheader &> /dev/null; then
    GRAPHICS_ARGS="-e WEBKIT_DISABLE_DMABUF_RENDERER=1 --device nvidia.com/gpu=all"
else
    echo "No NVIDIA GPU detected, using default rendering"
    GRAPHICS_ARGS=""
fi

podman run --rm \
    $DISPLAY_ARGS \
    $DBUS_ARGS \
    $GRAPHICS_ARGS\
    -v ${WORKDIR}:/work \
    --privileged localhost/stm32/stm32cubemon:latest