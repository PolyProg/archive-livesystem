%include ../base-live/fedora-live-base.ks
%include ../base-live/fedora-live-minimization.ks
%include ../base-live/fedora-xfce-packages.ks

%include polyprog-client-packages.ks
%include polyprog-client-minimization.ks


keyboard --vckeymap ch-fr --xlayouts='ch (fr)'

bootloader --append rd.live.ram=1


%post --nochroot
# copy files to system
rsync -raAHx $BASE_DIRECTORY/skel/* /mnt/sysimage/

%end


%post

useradd polyprog

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=polyprog/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# set Xfce as default session, otherwise login will fail
sed -i 's/^#user-session=.*/user-session=xfce/' /etc/lightdm/lightdm.conf


ln -s /usr/lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/

chown root:root /etc/NetworkManager/dispatcher.d/90-sethostname
chmod 755 /etc/NetworkManager/dispatcher.d/90-sethostname

chown root:root /etc/polkit-1/rules.d/00-restrict.rules
chown root:root /etc/salt/minion

chown root:root -R /usr/local/sbin

%end
