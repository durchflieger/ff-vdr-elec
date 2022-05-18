#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

VDR_ROOT_DIR=/storage/.config/vdr

if [ "$1" == "start" ] ; then
  [ -f ${VDR_ROOT_DIR}/vdr-frontend-hook.sh ] && /bin/sh ${VDR_ROOT_DIR}/vdr-frontend-hook.sh $1
  echo -e "plug softhdodroid atta\nremo on\nquit" | nc -w 20 localhost 6419
else
  echo -e "remo off\nplug softhdodroid deta\nquit" | nc -w 20 localhost 6419
  [ -f ${VDR_ROOT_DIR}/vdr-frontend-hook.sh ] && /bin/sh ${VDR_ROOT_DIR}/vdr-frontend-hook.sh $1
fi
