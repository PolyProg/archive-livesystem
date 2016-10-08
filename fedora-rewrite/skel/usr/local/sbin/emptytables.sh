#!/bin/sh

iptables="/sbin/iptables"

# Flush all rules
${iptables} --flush
${iptables} --delete-chain

# General policies: accept input and output
${iptables} --policy INPUT ACCEPT
${iptables} --policy FORWARD DROP
${iptables} --policy OUTPUT ACCEPT
