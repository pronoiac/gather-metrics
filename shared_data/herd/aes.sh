#!/bin/bash

# look for 'aes' in /proc/cpuinfo.
# datadog rules:
#   0: ok, 1: warning.
# so, here:
#   0: found, 1: absent

status=1
grep "aes" /proc/cpuinfo > /dev/null && status=0

echo "aes=$status"