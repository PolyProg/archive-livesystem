#!/bin/sh

exec "$(dirname "$0")/swerc_forall.sh" "DISPLAY=:0.0 sudo -u polyprog nohup xtrlock -b >/dev/null 2>&1 &"
