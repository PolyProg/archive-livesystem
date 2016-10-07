%include ../base-live/fedora-live-xfce.ks
%include polyprog-client-packages.ks
%include polyprog-client-minimization.ks

keyboard --vckeymap ch-fr --xlayouts='ch (fr)'

bootloader --append rd.live.ram

rootpw --plaintext $ROOTPW


%post --nochroot
# copy files to system
pwd
rsync -raAHx $BASE_DIRECTORY/skel/* $INSTALL_ROOT/

%end

%post
# enable services
ln -s /usr/lib/systemd/system/set-hostname.service /etc/systemd/system/multi-user.target.wants
%end
