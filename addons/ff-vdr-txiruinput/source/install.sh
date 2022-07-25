#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

FF_VDR_ADDON_NAME="ff-vdr-txiruinput"
SYSD_DIR=/storage/.config/system.d/eventlircd.service.d

echo "${FF_VDR_ADDON_NAME}/install.sh started"

. /etc/profile

oe_setup_addon ${FF_VDR_ADDON_NAME}

chmod a+x $ADDON_DIR/bin/txiruinput

if [ ! -f $ADDON_HOME/.installed ] ; then
	cp $ADDON_DIR/txiruinput.conf $ADDON_HOME
fi

touch $ADDON_DIR/.installed $ADDON_HOME/.installed

echo "${FF_VDR_ADDON_NAME}/install.sh done"
