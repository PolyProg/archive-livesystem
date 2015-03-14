#!/bin/sh

exec "$(dirname "$0")/hc2_forall.sh" "pkill xtrlock"
