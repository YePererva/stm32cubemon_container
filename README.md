# STM32CubeMonitor in a Container

This repository creates a container for [STM32CubeMonitor](https://www.st.com/en/development-tools/stm32cubemonitor.html).

Based on the project of [mobilinkd](https://github.com/mobilinkd/STM32CubeMonitor), this project accepts the raw downloaded zip-archive and adjusts to the version in the archive without hard-coding names in the script.

This container has only been tested with Fedora 42. Unfortunately, STMicroelectronics does not plan to provide an RPM distribution for STM32CubeMonitor, as indicated in the community [forum](https://community.st.com/t5/stm32cubemonitor-mcus/is-there-a-rpm-package-of-stm32cubemonitor/m-p/224300) discussion.

## Prerequisites and use

Make sure that your sustem has `podman` installed. Optionally, install `git` too. 

1. Download and unpack this repository or git clone it.
2. Download [STM32CubeMonitor](https://www.st.com/en/development-tools/stm32cubemonitor.html) from the web-site. You'll need the registered account with ST.
3. Place the downloaded archive as is into `distro` sub-folder of this repository
4. Run the `00._install.sh` script. Run NOT as root.
5. Run the `01._create_system_link.sh` as root, to install the system-wide link and being able to launch it as `stm32cubemon` from terminal
6. If you want to have a menu shortcut, also run `02._create_menu_entry.sh` as root to have system-wide shortcut.

For example:

```bash
cd ~/Downloads
sudo dnf install podman git

git clone https://github.com/YePererva/stm32cubemon_container.git

cd stm32cubemon_container

## at this point download the STM32CUbeMonitor from the STMicroelectronics web-site
## and place archive into the subfolder distro

sh 00._install.sh # intentionally no sudo here!
sudo sh 01._create_system_link.sh
sudo sh 02.create_menu_entry.sh
```

## Running STM32CubeMonitor

To run the application, simply call `stm32cubemon` from the terminal or use the system-wide `st-stm32cubemon.desktop` shortcut. 

Alternaltively, if no links were created,  you can run the script `templates\STM32CubeMonitor.sh` from this repository as is or call it via:

```bash 
STM32CubeMonitor.sh {ProjectFolder}
```

to run in specific folder.

## Spotted issues / Remarks

- For some reason, Fedora 42 with KDE Plasma is not always adding the shortcut to menu. But it can be found in Applications. Still looking for solution.
- If need to delete created container (per-say to intall the newer one):

```bash
sh 03._delete_old_containers.sh
```
