#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

VDR_ROOT_DIR=/storage/.config/vdr

[ -f ${VDR_ROOT_DIR}/vdr-frontend-hook.sh ] && exec /bin/sh ${VDR_ROOT_DIR}/vdr-frontend-hook.sh $1
