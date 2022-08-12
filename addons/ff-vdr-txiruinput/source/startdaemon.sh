#!/bin/sh

. /etc/profile

oe_setup_addon ff-vdr-txiruinput

if [ -z "$1" ] ; then
	exec $ADDON_DIR/bin/txiruinput -c $ADDON_HOME/txiruinput.conf -s /run/txiruinput -i -l 3 -w 0
fi

# TV power on, OSD on, Input HDMI, 16:9 Aspekt, PIP off, Mute off
STARTCMDS="LGE 0101\nLGE 0B01\nLGE 1C90\nLGE 0202\nLGE 0D00\nLGE 0400\nEXIT"

while [ ! -S /run/txiruinput ] ; do
	sleep 0.1
done
. /opt/etc/profile
echo -e "$STARTCMDS" | socat -t 30 stdio unix-client:/run/txiruinput
