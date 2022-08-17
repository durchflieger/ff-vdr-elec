#!/bin/sh

FF_VDR_ADDON_NAME="ff-vdr-eventlircd"
. /etc/profile
oe_setup_addon ${FF_VDR_ADDON_NAME}

LIRC_CONFIG="--lircrc=$ADDON_HOME/lircrc"
#LIRC_CONFIG="--lircrc=$ADDON_HOME/lircrc-amp"
#VERBOSE="-vvv"

exec $ADDON_DIR/bin/ff-vdr-eventlircd -f --evmap=/etc/eventlircd.d --socket=/run/lirc/lircd --txir=/run/txiruinput $LIRC_CONFIG $VERBOSE >/dev/null 2>&1
