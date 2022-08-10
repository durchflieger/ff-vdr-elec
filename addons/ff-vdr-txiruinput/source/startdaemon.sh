#!/bin/sh

. /etc/profile

oe_setup_addon ff-vdr-txiruinput

exec $ADDON_DIR/bin/txiruinput -c $ADDON_HOME/txiruinput.conf -s /run/txiruinput -i -l 3 -w 0
