#!/bin/sh

FF_VDR_ADDON_NAME="ff-vdr-eventlircd"
. /etc/profile
oe_setup_addon ${FF_VDR_ADDON_NAME}

LGE_DEVICE="--lge-port=/dev/ttyUSB0"
LIRC_CONFIG="--lircrc=$ADDON_HOME/lircrc-serial"

# Wait for device up to 3 seconds
LGE_OPEN_RETRY="--lge-open-retry=30"

# TV power on, OSD on, Input HDMI, 16:9 Aspekt
LGE_TV_ON="--lge-on=0101,0B01,1C90,0202"

# TV power off
LGE_TV_OFF="--lge-off=0100"

#VERBOSE="-vvv"

exec $ADDON_DIR/bin/ff-vdr-eventlircd -f --evmap=/etc/eventlircd.d --socket=/run/lirc/lircd $LIRC_CONFIG $LGE_DEVICE $LGE_OPEN_RETRY $LGE_TV_ON $LGE_TV_OFF $VERBOSE >/dev/null 2>&1
