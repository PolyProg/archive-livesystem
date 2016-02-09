#!/bin/sh

parallel --gnu --no-notice --tag ssh -n -q {} "\"$@\"" :::: "$(dirname "$0")/sshlogin-bc.txt"
