#!/bin/sh

exec "$(dirname "$0")/hc2_forall.sh" "pkill xtrlock; DISPLAY=:0.0 sudo -u polyprog xset dpms force on"
