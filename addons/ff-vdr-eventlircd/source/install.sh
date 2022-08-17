#!/bin/sh

FF_VDR_ADDON_NAME="ff-vdr-eventlircd"
SYSD_DIR=/storage/.config/system.d/eventlircd.service.d

echo "${FF_VDR_ADDON_NAME}/install.sh started"

. /etc/profile

oe_setup_addon ${FF_VDR_ADDON_NAME}

chmod a+x $ADDON_DIR/bin/ff-vdr-eventlircd

if [ ! -f $ADDON_HOME/.installed ] ; then
	cp $ADDON_DIR/startservice.sh $ADDON_DIR/lircrc* $ADDON_HOME
	chmod a+x $ADDON_HOME/startservice.sh

	echo -e "[Service]\nExecStart=\nExecStart=$ADDON_HOME/startservice.sh\nTimeoutStopSec=10s" > $ADDON_DIR/override.conf
	mkdir -p $SYSD_DIR
	ln -sf $ADDON_DIR/override.conf $SYSD_DIR
fi

touch $ADDON_DIR/.installed $ADDON_HOME/.installed

echo "${FF_VDR_ADDON_NAME}/install.sh done"
