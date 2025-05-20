#!/bin/bash
template_file="templates/MenuEntry.desktop"
distro_folder="distro"

icon_destination="/usr/share/pixmaps"
menu_entry_dir="/usr/share/applications"
menu_entry_filename="$menu_entry_dir/st-stm32cubemon.desktop"

unpacked_folder="$distro_folder"/unpacked

echo "Unpacking the distro and extracting icon(s)"

rm -f "$menu_entry_filename"
rm -rf "$unpacked_folder"

distro_zip="$(basename -- "$(find "$distro_folder" -type f -name "en.stm32cubemon-lin-v*.zip")")"
version=$(echo "$distro_zip" | grep -oP 'v-\K\d+-\d+-\d+' | tr '-' '.')


unzip $distro_folder/$distro_zip -d "$unpacked_folder"
cubemon_path=""$(find "$unpacked_folder" -type f -name "stm32cubemonitor_*_amd64.deb")""

unpacked_deb="$unpacked_folder"/"$(basename -- "$cubemon_path" .deb)"
mkdir -p "$unpacked_deb"

ar x "$cubemon_path" "data.tar.zst" --output "$unpacked_deb"
unzstd "$unpacked_deb"/data.tar.zst 
mkdir -p "$unpacked_deb"/data 
tar -xf "$unpacked_deb"/data.tar -C "$unpacked_deb"/data 
cp "$unpacked_deb"/data"$icon_destination"/* "$icon_destination"

echo "Clean-up unpacked leftovers"
rm -rf "$unpacked_folder"

echo "Copying shortcut template and editing to system"

mkdir -p "$menu_entry_dir"

cp "$template_file" "$menu_entry_filename"
sed -i "s|{{version}}|${version//\\/\\\\}|g" "$menu_entry_filename"
sed -i "s|{{system_launcher}}|${system_launcher//\\/\\\\}|g" "$menu_entry_filename"


update-desktop-database "$menu_entry_filename" -v
chmod 644 "$menu_entry_filename"

kbuildsycoca5 --noincremental
kbuildsycoca6 --noincremental

xdg-desktop-menu install --mode system --novendor "${menu_entry_filename}"
xdg-desktop-menu forceupdate