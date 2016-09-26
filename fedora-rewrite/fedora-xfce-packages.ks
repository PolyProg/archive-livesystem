# fedora-livecd-xfce.ks
#
# Description:
# - Fedora Live Spin with the light-weight XFCE Desktop Environment
#
# Maintainer(s):
# - Rahul Sundaram    <sundaram@fedoraproject.org>
# - Christoph Wickert <cwickert@fedoraproject.org>
# - Kevin Fenzi       <kevin@tummy.com>
# - Adam Miller       <maxamillion@fedoraproject.org>


%packages

@networkmanager-submodules
@xfce-desktop
@xfce-apps
@xfce-extra-plugins
@xfce-media
@xfce-office

# unlock default keyring. FIXME: Should probably be done in comps
gnome-keyring-pam
# Admin tools are handy to have
@admin-tools
# Add some screensavers, people seem to like them
# Note that blank is still default.
xscreensaver-extras
wget
# Handy for debugging
rfkill
# Better more popular browser
firefox
system-config-printer

# save some space
-autofs
-acpid
-gimp-help
-desktop-backgrounds-basic
-realmd                     # only seems to be used in GNOME
-PackageKit*                # we switched to yumex, so we don't need this
-aspell-*                   # dictionaries are big
-xfce4-sensors-plugin

## PolyProg

# compiler / executor
gcc
jdk-1.8.0-openjdk-devel
python2
python3
ruby
scala
#clang TODO

# debugger
gdb
ddd
#jdb TODO
pydb

# dev tools
inotify-tools
make
#xrandr TODO
#tup TODO

# ide
eclipse
emacs
gedit
geany
nano
vim
scite
#sublime text TODO
#intellij TODO

# other
acpi
avahi
#setxkbmap
firefox

%end