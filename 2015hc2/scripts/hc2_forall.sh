#!/bin/sh

parallel --gnu --tag ssh -n -q {} "\"$@\"" :::: "$(dirname "$0")/hc2-sshlogin.txt"
