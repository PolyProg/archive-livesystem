#!/bin/sh

parallel --gnu --no-notice --tag ssh -n -q {} "\"$@\"" :::: "$(dirname "$0")/swerc-sshlogin.txt"
