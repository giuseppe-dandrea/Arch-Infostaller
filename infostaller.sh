info_messages=(
"Welcome to Arch Infostaller

Usage:
arch_help - To display current installation phase
arch_next - To go to the next installation phase
arch_prev - To go to the previous installation phase

For more information visit https://wiki.archlinux.org/index.php/Installation_guide

Note: To navigate to a specific phase of the installation set the n variable
	# n=2
The next call of arch_help will show the first phase of the installation.
Note: n=1 is this help message"


"Set the keyboard layout

The default console keymap is US. Available layouts can be listed with:

	# ls /usr/share/kbd/keymaps/**/*.map.gz

To modify the layout, append a corresponding file name to loadkeys, omitting path and file extension. For example, to set a German keyboard layout:

	# loadkeys de-latin1"

"Verify the boot mode

If UEFI mode is enabled on an UEFI motherboard, Archiso will boot Arch Linux accordingly via systemd-boot. To verify this, list the efivars directory:

	# ls /sys/firmware/efi/efivars

If the directory does not exist, the system may be booted in BIOS or CSM mode. Refer to your motherboard's manual for details."

"Connect to the internet

To set up a network connection, go through the following steps:

	Ensure your network interface is listed and enabled, for example with ip-link:
		# ip link
	Connect to the network. Plug in the Ethernet cable or connect to the wireless LAN.
	Configure your network connection:
		Static IP address
		Dynamic IP address: use DHCP.
			Note: The installation image enables dhcpcd (dhcpcd@interface.service) for wired network devices on boot.

	The connection may be verified with ping:
		# ping archlinux.org"

"Update the system clock

Use timedatectl to ensure the system clock is accurate:

	# timedatectl set-ntp true

To check the service status, use: 
	# timedatectl status"

"Partition the disks

When recognized by the live system, disks are assigned to a block device such as /dev/sda or /dev/nvme0n1. To identify these devices, use lsblk or fdisk.

	# fdisk -l

Results ending in rom, loop or airoot may be ignored.

The following partitions are required for a chosen device:

	One partition for the root directory /.
	If UEFI is enabled, an EFI system partition.

Note: If you want to create any stacked block devices for LVM, system encryption or RAID, do it now.

Note:
Use fdisk or parted to modify partition tables, for example 
	# fdisk /dev/sdX.
Swap space can be set on a swap file for file systems supporting it."

"Format the partitions

Once the partitions have been created, each must be formatted with an appropriate file system. For example, if the root partition is on /dev/sdX1 and will contain the ext4 file system, run:
	# mkfs.ext4 /dev/sdX1

Usually the EFI partition use a FAT32 filesystem
	# mkfs.fat -F32 /dev/sdxY

If you created a partition for swap, initialize it with mkswap:
	# mkswap /dev/sdX2
	# swapon /dev/sdX2"

"Mount the file systems

Mount the file system on the root partition to /mnt, for example:
	# mount /dev/sdX1 /mnt

Create any remaining mount points (such as /mnt/efi) and mount their corresponding partitions.

genfstab will later detect mounted file systems and swap space."

"Select the mirrors

Packages to be installed must be downloaded from mirror servers, which are defined in /etc/pacman.d/mirrorlist. On the live system, all mirrors are enabled, and sorted by their synchronization status and speed at the time the installation image was created.

The higher a mirror is placed in the list, the more priority it is given when downloading a package. You may want to edit the file accordingly, and move the geographically closest mirrors to the top of the list, although other criteria should be taken into account.

This file will later be copied to the new system by pacstrap, so it is worth getting right."

"Install essential packages

Use the pacstrap script to install the base (base-devel) package, Linux kernel and firmware for common hardware:
	# pacstrap /mnt base linux linux-firmware
Tip: You can substitute linux for a kernel package of your choice. You can omit the installation of the kernel or the firmware package if you know what you are doing.

The base package does not include all tools from the live installation, so installing other packages may be necessary for a fully functional base system. In particular, consider installing:

	userspace utilities for the management of file systems that will be used on the system,
	utilities for accessing RAID or LVM partitions,
	specific firmware for other devices not included in linux-firmware,
	software necessary for networking,
	a text editor,
	packages for accessing documentation in man and info pages: man-db, man-pages and texinfo.

To install other packages or package groups, append the names to the pacstrap command above (space separated) or use pacman while chrooted into the new system. For comparison, packages available in the live system can be found in packages.x86_64."

"Fstab

Generate an fstab file (use -U or -L to define by UUID or labels, respectively):
	# genfstab -U /mnt >> /mnt/etc/fstab

Check the resulting /mnt/etc/fstab file, and edit it in case of errors."

"Copy infostaller.sh to new system

Copy the infostaller to let the help continue on the chrooted system
	# cp infostaller.sh /mnt/home"

"Chroot

Change root into the new system:
	# arch-chroot /mnt

Now source again the infostaller and set the page to the new root enviroment
	# source /home/infostaller.sh
	# n=13
"

"Time zone

Set the time zone:
	# ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
	
Run hwclock to generate /etc/adjtime:
	# hwclock --systohc

This command assumes the hardware clock is set to UTC. See System time#Time standard for details."

"Localization

Uncomment en_US.UTF-8 UTF-8 and other needed locales in /etc/locale.gen, and generate them with:
	# locale-gen

Create the locale.conf file, and set the LANG variable accordingly:
	/etc/locale.conf
		LANG=en_US.UTF-8

If you set the keyboard layout, make the changes persistent in vconsole.conf:
	/etc/vconsole.conf
		KEYMAP=de-latin1"

"Network configuration

Create the hostname file:
	/etc/hostname
		myhostname

Add matching entries to hosts:
	/etc/hosts
		127.0.0.1	localhost
		::1		localhost
		127.0.1.1	myhostname.localdomain	myhostname

If the system has a permanent IP address, it should be used instead of 127.0.1.1.

Complete the network configuration for the newly installed environment, that includes installing your preferred network management software."

"Initramfs

Creating a new initramfs is usually not required, because mkinitcpio was run on installation of the kernel package with pacstrap.

For LVM, system encryption or RAID, modify mkinitcpio.confand recreate the initramfs image:
	# mkinitcpio -P"

"Root password

Set the root password:
	# passwd"

"Boot loader

Choose and install a Linux-capable boot loader. If you have an Intel or AMD CPU, enable microcode updates in addition.

Note: in the next phase will be the instruction to install GRUB on an EFI system"

"Grub

Note: skip if you have installed another boot loader in the previous phase

First, install the packages grub and efibootmgr: GRUB is the bootloader while efibootmgr is used by the GRUB installation script to write boot entries to NVRAM.

Then follow the below steps to install GRUB:
	Mount the EFI system partition and in the remainder of this section, substitute esp with its mount point.
	Choose a bootloader identifier, here named GRUB. A directory of that name will be created in esp/EFI/ to store the EFI binary and this is the name that will appear in the UEFI boot menu to identify the GRUB boot entry.
	Execute the following command to install the GRUB EFI application grubx64.efi to esp/EFI/GRUB/ and install its modules to /boot/grub/x86_64-efi/.
		# grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB

	After the above install completed the main GRUB directory is located at /boot/grub/. Note that grub-install also tries to create an entry in the firmware boot manager, named GRUB in the above example.

Note: before executing the next step, mount all other partitions containing operating systems you want to include in grub.

Use the grub-mkconfig tool to generate /boot/grub/grub.cfg:
	# grub-mkconfig -o /boot/grub/grub.cfg"

"Reboot

Exit the chroot environment by typing exit or pressing Ctrl+d.

Optionally manually unmount all the partitions with umount -R /mnt: this allows noticing any 'busy' partitions, and finding the cause with fuser.

Finally, restart the machine by typing reboot: any partitions still mounted will be automatically unmounted by systemd. Remember to remove the installation media and then login into the new system with the root account."
)

n=1

arch_help() {
	echo ""
	echo "###################"
	echo ""
	echo "${info_messages[@]:$((n-1)):$n}"
	echo ""
	echo "###################"
	echo ""
}

arch_next() {
	n=$((n+1))
	arch_help
}
arch_prev() {
	n=$((n-1))
	arch_help
}
