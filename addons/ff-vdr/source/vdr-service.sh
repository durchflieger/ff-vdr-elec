#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

. /etc/profile

oe_setup_addon ff-vdr

VDR_ROOT_DIR=/storage/.config/vdr
VDR_CACHE_DIR=/storage/.cache/vdr

[ -z "$LANG" ] && export LANG=C.UTF-8

find $VDR_ROOT_DIR/command-hooks -maxdepth 1 -name '*.conf' | sort | xargs cat > $VDR_CACHE_DIR/commands.conf

killall splash-image

exec $ADDON_DIR/bin/vdr
