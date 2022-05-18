#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

FF_VDR_ADDON_NAME="ff-vdr-eventlircd"
SYSD_DIR=/storage/.config/system.d/eventlircd.service.d

echo "${FF_VDR_ADDON_NAME}/install.sh started"

. /etc/profile

oe_setup_addon ${FF_VDR_ADDON_NAME}

chmod a+x $ADDON_DIR/bin/eventlircd-lge

if [ ! -f $ADDON_HOME/.installed ] ; then
	cp $ADDON_DIR/startservice.sh $ADDON_DIR/lircrc $ADDON_HOME

	mkdir -p $SYSD_DIR
	cp $ADDON_DIR/override.conf $SYSD_DIR
	systemctl daemon-reload
fi

touch $ADDON_DIR/.installed $ADDON_HOME/.installed

echo "${FF_VDR_ADDON_NAME}/install.sh done"
