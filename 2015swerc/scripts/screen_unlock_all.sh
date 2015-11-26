#!/bin/sh

exec "$(dirname "$0")/swerc_forall.sh" "pkill xtrlock; DISPLAY=:0.0 sudo -u polyprog xset dpms force on"
