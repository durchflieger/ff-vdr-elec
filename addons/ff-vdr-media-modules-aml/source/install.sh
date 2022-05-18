#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

FF_VDR_ADDON_NAME="ff-vdr-media-modules-aml"

echo "${FF_VDR_ADDON_NAME}/install.sh started"

. /etc/profile

oe_setup_addon ${FF_VDR_ADDON_NAME}

if [ ! -f $ADDON_DIR/.installed ] ; then
  echo "${ADDON_DIR}/overlay" > /storage/.cache/kernel-overlays/${FF_VDR_ADDON_NAME}.conf
fi

touch $ADDON_DIR/.installed $ADDON_HOME/.installed

echo "${FF_VDR_ADDON_NAME}/install.sh done"
