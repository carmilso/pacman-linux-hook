# pacman-linux-hook
Generates a pacman hook to update Linux version in the grub configuration file. Grub entries are updated with the corresponding Linux version each time Linux package is updated.

## Getting started

### Prerequisites
To use this script you need:
* [pacman](https://www.archlinux.org/pacman/)
* A grub configuration file passed as ENV variable (by default in /boot/grub/grub.cfg)

### How to use It
By default:

```
git clone git@github.com:carmilso/pacman-linux-hook.git
cd pacman-linux-hook
./createPacmanLinuxHook.sh
```
Passing grub configuration file as ENV variable:

```
git clone git@github.com:carmilso/pacman-linux-hook.git
cd pacman-linux-hook
GRUB_CFG=/boot/grub.cfg ./createPacmanLinuxHook.sh
```

### What do we create executing the script?
* The pacman hook in /etc/pacman.d/hooks/linux-post.hook
* The script to be executed with a Linux update in /usr/local/bin/linux-post-hook.sh

### After updating Linux...

If we have something like this in the `/boot/grub/grub.cfg` (with Linux 4.10.8-1):

```
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-43ef0b61-66cc-4d35-ab56-694452acbce8' {
	load_video
	set gfxpayload=keep
	insmod gzio
	insmod part_gpt
	insmod fat
	set root='hd0,gpt1'
	if [ x$feature_platform_search_hint = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt1 --hint-efi=hd0,gpt1 --hint-baremetal=ahci0,gpt1  902A-9AB7
	else
	  search --no-floppy --fs-uuid --set=root 902A-9AB7
	fi
	echo	'Loading Linux 4.10.8-1-x86_64...'
	linux	/vmlinuz-linux root=UUID=43ef0b61-66cc-4d35-ab56-694452acbce8 rw  quiet
	echo	'Loading initial ramdisk...'
	initrd  /initramfs-linux.img
```

And we update Linux (to 4.10.9-1), the hook will be executed and We will have this (in all the grub entries):

```
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-43ef0b61-66cc-4d35-ab56-694452acbce8' {
	load_video
	set gfxpayload=keep
	insmod gzio
	insmod part_gpt
	insmod fat
	set root='hd0,gpt1'
	if [ x$feature_platform_search_hint = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt1 --hint-efi=hd0,gpt1 --hint-baremetal=ahci0,gpt1  902A-9AB7
	else
	  search --no-floppy --fs-uuid --set=root 902A-9AB7
	fi
	echo	'Loading Linux 4.10.9-1-x86_64...'
	linux	/vmlinuz-linux root=UUID=43ef0b61-66cc-4d35-ab56-694452acbce8 rw  quiet
	echo	'Loading initial ramdisk...'
	initrd  /initramfs-linux.img
```
