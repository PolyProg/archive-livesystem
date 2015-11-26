#!/bin/sh

exec "$(dirname "$0")/swerc_forall.sh" "systemctl stop lightdm.service; rsync -a --delete /etc/skel/ /home/polyprog; chown -R polyprog:polyprog /home/polyprog/; rm -r /tmp/* /tmp/.[^.]*; systemctl start lightdm.service"
