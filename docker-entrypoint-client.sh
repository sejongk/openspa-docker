#!/bin/bash

#{
#  echo "" | dd bs=256 conv=sync
#  echo "" | dd bs=256 conv=sync
#  echo "" | dd bs=256 conv=sync
#  echo "" | dd bs=256 conv=sync
#  echo "" | dd bs=256 conv=sync
#  echo "" | dd bs=256 conv=sync
#  echo "" | dd bs=256 conv=sync
#} 2>/dev/null | ./openspa-tools gen-client clients/server.pub -o clients

exec $@
