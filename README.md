# Pacman Linux hook

Generates a pacman hook to update Linux version in the grub configuration file. Grub entries are updated with the correct Linux version every time the Linux package is updated.

## Getting started

### Prerequisites

To use this script you need:
* [pacman](https://www.archlinux.org/pacman/)
* A grub configuration file passed as environment variable (by default in `/boot/grub/grub.cfg`)

### How to use It

By default:

```console
git clone git@github.com:carmilso/pacman-linux-hook.git
cd pacman-linux-hook
./createPacmanLinuxHook.sh
```

Passing grub configuration file path as environment variable:

```console
git clone git@github.com:carmilso/pacman-linux-hook.git
cd pacman-linux-hook
GRUB_CFG=/boot/grub.cfg ./createPacmanLinuxHook.sh
```

### What is created when the script is executed?
* The post-install pacman hook that will run every time the Linux package is updated in `/etc/pacman.d/hooks/linux-post.hook`
* The script that updates the Linux version in the grub configuration file in `/usr/local/bin/linux-post-install-pacman-hook.sh`

### After updating Linux...

There are two possible scenarios:
  * The hook has never been executed before
  * The grub configuration file already contains the Linux version

Before the update, in this first case we should have something similar to this inside the grub configuration file:

```
(...)
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-43ef0b61-66cc-4d35-ab56-694452acbce8' {
  (...)
  echo 'Loading Linux linux ...'
  (...)
}
(...)
```

Therefore, the result after running the script will be (in case Linux is being updated to version 5.5.13.arch1-1):

```
(...)
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-43ef0b61-66cc-4d35-ab56-694452acbce8' {
  (...)
  echo 'Loading Linux 5.5.13.arch1-1 ...'
  (...)
}
(...)
```

Before the update, in the second case we will already have the Linux version in the grub configuration file since the script has been executed before:

```
(...)
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-43ef0b61-66cc-4d35-ab56-694452acbce8' {
  (...)
  echo  'Loading Linux 5.5.12.arch1-1 ...'
  (...)
}
(...)
```

Therefore, the result after running the script will be (in case Linux is being updated to version 5.5.13.arch1-1):

```
(...)
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-43ef0b61-66cc-4d35-ab56-694452acbce8' {
  (...)
  echo  'Loading Linux 5.5.13.arch1-1 ...'
  (...)
}
(...)
```
