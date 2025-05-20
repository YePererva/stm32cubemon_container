#!/bin/bash
template_file="templates/Containerfile"
container_file="Containerfile"

if [ ! -f "$template_file" ]; then
    echo "Error: Template file '$template_file' not found!"
    exit 1
fi

distro_folder="distro"
distro_zip="$(basename -- "$(find "$distro_folder" -type f -name "en.stm32cubemon-lin-v*.zip")")"
unpacked_folder="$distro_folder"/unpacked

echo "Purge of accidential leftovers"

rm -f "$container_file"
rm -rf "$unpacked_folder"

echo "Decompression and detection the version"
mkdir -p "$unpacked_folder"
unzip $distro_folder/$distro_zip -d "$unpacked_folder"

driver_path=""$(find "$unpacked_folder" -type f -name "st-stlink-udev-rules-*.deb")""
cubemon_path=""$(find "$unpacked_folder" -type f -name "stm32cubemonitor_*_amd64.deb")""

echo "Creating the Containerfile"
cp "$template_file" "$container_file"
sed -i "s|{{driver_path}}|${driver_path//\\/\\\\}|g" "$container_file"
sed -i "s|{{cubemon_path}}|${cubemon_path//\\/\\\\}|g" "$container_file"

echo "Running Podman to build the container"
podman build -t stm32/stm32cubemon .

echo "Clean-up"
rm -rf "$unpacked_folder"
rm -rf "$container_file"
