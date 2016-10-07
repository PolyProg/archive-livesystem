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
-xfce4-dict-plugin
-xfce4-screenshooter-plugin
-system-config-printer
-gnome-disk-utility

-openssh-clients
-openssh-askpass
-open-vm-tools-desktop
# -memtest86+ FIXME this is not feasible because of boot... see x86.tmpl ?
%end




%post
dnf remove -y claws-mail f24-backgrounds-gnome firewalld pulseaudio gnome-abrt

dnf clean all
%end
