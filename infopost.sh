info_messages=(
"Welcome to Arch Infostaller - Post Installation

Usage:
arch_help - To display current installation phase
arch_next - To go to the next installation phase
arch_prev - To go to the previous installation phase

For more information visit https://wiki.archlinux.org/index.php/General_recommendations

Note: To navigate to a specific phase of the installation set the n variable
	# n=2
The next call of arch_help will show the second phase of the installation."

"Users and groups

A new installation leaves you with only the superuser account, better known as 'root'. Logging in as root for prolonged periods of time, possibly even exposing it via SSH on a server, is insecure. Instead, you should create and use unprivileged user account(s) for most tasks, only using the root account for system administration. See Users and groups#User management for details.

Users and groups are a mechanism for access control; administrators may fine-tune group membership and ownership to grant or deny users and services access to system resources. Read the Users and groups article for details and potential security risks.

Create a new user with:
	# useradd -m -G addiotional_groups -s login_shell username
		Note: -m == --create-home

Although it is not required to protect the newly created user archie with a password, it is highly recommended to do so:
	# passwd archie"

"Privilege elevation

Both the su and sudo commands allow you to run commands as another user. su by default starts an interactive shell as the root user, and sudo by default temporarily grants you root privileges for a single command. See their respective articles for differences. opendoas is a lighter alternative to sudo."

"Microcode

Processors may have faulty behaviour, which the kernel can correct by updating the microcode on startup. See Microcode for details."

"Xorg

Xorg is the public, open-source implementation of the X Window System (commonly X11, or X). It is required for running applications with graphical user interfaces (GUIs), and the majority of users will want to install it.

Wayland is a newer, alternative display server protocol and the Weston reference implementation is available.

You can install xorg-server or the group xorg which contains xorg-server, packages from the xorg-apps group and fonts."

"GPU Driver

The Linux kernel includes open-source video drivers and support for hardware accelerated framebuffers. However, userland support is required for OpenGL and 2D acceleration in X11.

First, identify your card:
	$ lspci | grep -e VGA -e 3D

Then install an appropriate driver. You can search the package database for a complete list of open-source video drivers:
	$ pacman -Ss xf86-video

Xorg searches for installed drivers automatically:
	If it cannot find the specific driver installed for the hardware (listed below), it first searches for fbdev (xf86-video-fbdev).
	If that is not found, it searches for vesa (xf86-video-vesa), the generic driver, which handles a large number of chipsets but does not include any 2D or 3D acceleration.
	If vesa is not found, Xorg will fall back to kernel mode setting, which includes GLAMOR acceleration (see modesetting(4)).

In order for video acceleration to work, and often to expose all the modes that the GPU can set, a proper video driver is required, visit https://wiki.archlinux.org/index.php/Xorg#Driver_installation for further informations"

"Graphical User Interface

Install your favourite Desktop Environment or Window Manager"

"Fonts

You may wish to install a set of TrueType fonts, as only unscalable bitmap fonts are included in a basic Arch system. There are several general-purpose font families providing large Unicode coverage and even metric compatibility with fonts from other operating systems.

A plethora of information on the subject can be found in the Fonts and Font configuration articles.

If spending a significant amount of time working from the virtual console (i.e. outside an X server), users may wish to change the console font to improve readability; see Linux console#Fonts."

"yay

To install yay:
	# git clone https://aur.archlinux.org/yay.git
	# cd yay
	# makepkg -si"

"Alternative shells
Bash is the shell that is installed by default in an Arch system. The live installation media, however, uses zsh with the grml-zsh-config addon package. See Command-line shell#List of shells for more alternatives."
)

n=0

arch_help() {
	echo ""
	echo "###################"
	echo ""
	echo "${info_messages[@]:$n:1}"
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

