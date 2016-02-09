#!/bin/sh

exec "$(dirname "$0")/forall.sh" "pkill xtrlock; DISPLAY=:0.0 sudo -u polyprog xset dpms force on"
