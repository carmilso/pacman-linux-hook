#!/bin/bash

# This script creates:
# - The post-install hook in /etc/pacmand.d/hooks/linux-post.hook
# - The post-install script that updates the linux version in the grub config


grub_cfg="${GRUB_CFG:-/boot/grub/grub.cfg}"
hook_pacman="/etc/pacman.d/hooks/linux-post.hook"
hook_script="/usr/local/bin/linux-post-hook.sh"

die() {
  echo "$@"
  exit 1
}

echo ""
echo "##########       ##         ##########    ##      ##         ##         ###     ##"
echo "##      ##      ####        ##            ###    ###        ####        ## ##   ##"
echo "##########     ##  ##       ##            ## #### ##       ##  ##       ##  ##  ##"
echo "##            ########      ##            ##      ##      ########      ##   ## ##"
echo "##           ##      ##     ##            ##      ##     ##      ##     ##    ####"
echo "##          ##        ##    ##########    ##      ##    ##        ##    ##     ###"
echo ""

which pacman &>/dev/null || die "pacman not installed. Exiting ..."

test -f "${grub_cfg}" || die "Boot config file '${grub_cfg}' not available. Please, create it before activating the hook. Exiting ..."

sudo mkdir -p "${hook_pacman%/*}"
sudo mkdir -p "${hook_script%/*}"

echo "Generating pacman hook ..."

sudo tee <<EOF "${hook_pacman}" &>/dev/null
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux*

[Action]
Description = Update Linux version in the grub
When = PostTransaction
Exec = ${hook_script}
EOF

echo "Generating hook script ..."

sudo tee <<EOF "${hook_script}" &>/dev/null
#!/bin/bash


linux_version="\$(pacman -Q linux | tr -s ' ' | cut -d' ' -f2)"
echo "Updating Linux version in grub to \${linux_version} ..."

sed -i.bak 's/\(Linux\s\+\)\(linux\|\(\w\+\.\)\{2\}\(\w\|-\)\+\)/\1'"\${linux_version}"'/g' ${grub_cfg}
EOF

sudo chmod +x "${hook_script}"
