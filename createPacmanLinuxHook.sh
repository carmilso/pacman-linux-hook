#!/bin/bash

# This script creates:
# - The post-install pacman hook that will run every time the linux package is updated
# - The script that updates the linux version in the grub config file


grub_cfg="${GRUB_CFG:-/boot/grub/grub.cfg}"
hook_pacman="/etc/pacman.d/hooks/linux-post.hook"
hook_script="/usr/local/bin/linux-post-install-pacman-hook.sh"

die() {
  echo "$@"
  exit 1
}

cat << EOF

  ____   _    ____ __  __    _    _   _
 |  _ \ / \  / ___|  \/  |  / \  | \ | |
 | |_) / _ \| |   | |\/| | / _ \ |  \| |
 |  __/ ___ \ |___| |  | |/ ___ \| |\  |
 |_| /_/   \_\____|_|  |_/_/   \_\_| \_|


EOF

command -v pacman &>/dev/null || die "pacman not installed. Exiting ..."

test -f "${grub_cfg}" || die "Boot config file '${grub_cfg}' not available. Please, create it before activating the hook. Exiting ..."

sudo mkdir -p "${hook_pacman%/*}"
sudo mkdir -p "${hook_script%/*}"

echo "Generating pacman hook ..."

sudo tee <<EOF "${hook_pacman}" &>/dev/null
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux

[Action]
Description = Updating Linux version in the grub configuration file...
When = PostTransaction
Exec = ${hook_script}
EOF

echo "Generating hook script ..."

sudo tee << EOF "${hook_script}" &>/dev/null
#!/bin/bash

linux_version="\$(pacman -Q linux | awk '{ print \$2 }')"

sed -i.bak -E \\
  -e 's/Linux\s+linux/Linux '"\${linux_version}"'/g' \\
  -e 's/Linux\s+([0-9]+\.?){3}(\w|-|[0-9])*/Linux '"\${linux_version}"'/g' \\
  ${grub_cfg}
EOF

sudo chmod +x "${hook_script}"
