%packages

-sudo # we have a root pwd anyway
-@Sound and Video
-@printing
-@xfce-extra-plugins
-@xfce-media
-@xfce-office
-ristretto
-pidgin
-transmission
-orage
-yumex-dnf
-smartmontools
-blueman
-xscreensaver-extras
-xscreensaver-base
-xfce4-dict-plugin
-xfce4-screenshooter-plugin
-system-config-printer
-gnome-disk-utility
-openssh-clients
-openssh-askpass
-open-vm-tools-desktop
-seahorse
-telnet
-lvm2
-chrony
-qemu-guest-agent
-nfs-utils
-xorg-x11-drv-wacom
-xorg-x11-drv-vmware

-openconnect
-pulseaudio-libs
# -memtest86+ FIXME this is not feasible because of boot... see x86.tmpl ?
%end




%post
dnf remove -y claws-mail f24-backgrounds-gnome firewalld pulseaudio gnome-abrt ModemManager abrt openvpn vpnc openconnect gnome-keyring pulseaudio-libs
dnf clean all
%end
