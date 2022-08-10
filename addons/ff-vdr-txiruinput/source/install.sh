#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

FF_VDR_ADDON_NAME="ff-vdr-txiruinput"
UDEV_DIR=/storage/.config/udev.rules.d

echo "${FF_VDR_ADDON_NAME}/install.sh started"

. /etc/profile

oe_setup_addon ${FF_VDR_ADDON_NAME}

chmod a+x $ADDON_DIR/bin/txiruinput

if [ ! -f $ADDON_HOME/.installed ] ; then
	cp $ADDON_DIR/txiruinput.conf $ADDON_HOME
	echo "ACTION==\"add\", SUBSYSTEM==\"usb\", ATTR{idVendor}==\"16c0\", ATTR{idProduct}==\"05dc\", ENV{ID_MODEL}==\"USBTXIR\", ENV{ID_SERIAL_SHORT}==\"AP\", RUN=\"$ADDON_DIR/bin/txiruinput -b %E{BUSNUM} -d %E{DEVNUM} -c $ADDON_HOME/txiruinput.conf -s /run/txiruinput -i -D -l 1 -w 0\"" > $ADDON_HOME/45-txiruinput.rules
	ln -sf $ADDON_HOME/45-txiruinput.rules $UDEV_DIR
	ln -sf $ADDON_DIR/98-eventlircd-txiruinput.rules $UDEV_DIR
fi

touch $ADDON_DIR/.installed $ADDON_HOME/.installed

echo "${FF_VDR_ADDON_NAME}/install.sh done"
