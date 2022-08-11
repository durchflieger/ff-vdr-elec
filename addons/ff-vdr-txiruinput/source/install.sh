#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

FF_VDR_ADDON_NAME="ff-vdr-txiruinput"
UDEV_DIR=/storage/.config/udev.rules.d

echo "${FF_VDR_ADDON_NAME}/install.sh started"

. /etc/profile

oe_setup_addon ${FF_VDR_ADDON_NAME}

chmod a+x $ADDON_DIR/bin/txiruinput $ADDON_DIR/startdaemon.sh

echo -e "[Unit]\nDescription=USBTXIR-Daemon\n\n[Service]\nExecStart=$ADDON_HOME/startdaemon.sh" > $ADDON_DIR/txiruinput.service
ln -sf $ADDON_DIR/txiruinput.service /storage/.config/system.d
ln -sf $ADDON_DIR/45-txiruinput.rules /storage/.config/udev.rules.d
ln -sf $ADDON_DIR/98-eventlircd-txiruinput.rules /storage/.config/udev.rules.d

if [ ! -f $ADDON_HOME/.installed ] ; then
	cp $ADDON_DIR/txiruinput.conf $ADDON_HOME
	cp $ADDON_DIR/startdaemon.sh $ADDON_HOME
fi

touch $ADDON_DIR/.installed $ADDON_HOME/.installed

echo "${FF_VDR_ADDON_NAME}/install.sh done"
