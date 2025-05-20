#!/bin/bash

# Used as separate script, since calling original installation as root gives a root owning of container
launcher_destination="/usr/local/bin"
launcher_script="templates/STM32CubeMonitor.sh"

system_launcher="$launcher_destination"/stm32cubemon

echo "Copying launcher"

rm -f "$system_launcher"
cp "$launcher_script" "$system_launcher"
chmod +x "$system_launcher"
