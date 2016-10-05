%include fedora-live-xfce.ks
%include polyprog-client-packages.ks

keyboard --vckeymap ch-fr --xlayouts='ch fr'

bootloader --append rd.live.ram

rootpw --plaintext $ROOTPW

# set hostname
%post --nochroot
cp set_hostname $INSTALL_ROOT/usr/sbin/set_hostname
%end
%post
cat > /usr/lib/systemd/system/set-hostname.service << EOF
[Unit]
Description=Set hostname for live server
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/set_hostname

[Install]
WantedBy=multi-user.target
EOF

ln -s /usr/lib/systemd/system/set-hostname.service /etc/systemd/system/multi-user.target.wants
%end

# add wifi cert
%post --nochroot
cp thawte_Primary_Root_CA.pem $INSTALL_ROOT/etc/ssl/certs
%end
