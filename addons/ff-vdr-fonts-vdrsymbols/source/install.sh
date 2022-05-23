#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

FF_VDR_ADDON_NAME="ff-vdr-fonts-vdrsymbols"
#FONTCONFIG_DIR=/storage/.fonts.conf.d
FONTCONFIG_DIR=/storage/.config/fontconfig/conf.d

echo "${FF_VDR_ADDON_NAME}/install.sh started"

. /etc/profile

oe_setup_addon ${FF_VDR_ADDON_NAME}

mkdir -p $FONTCONFIG_DIR
ln -sf $ADDON_DIR/90-vdrsymbols.conf $FONTCONFIG_DIR

touch $ADDON_DIR/.installed $ADDON_HOME/.installed

echo "${FF_VDR_ADDON_NAME}/install.sh done"
