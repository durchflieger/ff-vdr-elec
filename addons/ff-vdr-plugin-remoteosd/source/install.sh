#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

VDR_PLUGIN_NAME="remoteosd"

echo "ff-vdr-plugin-${VDR_PLUGIN_NAME}/install.sh started"

. /etc/profile

oe_setup_addon ff-vdr-plugin-${VDR_PLUGIN_NAME}

VDR_ROOT_DIR=/storage/.config/vdr

for d in args plugins locale ; do
  mkdir -p $VDR_ROOT_DIR/$d
done

rm -f $VDR_ROOT_DIR/plugins/libvdr-${VDR_PLUGIN_NAME}.so.*
ln -sf $ADDON_DIR/libvdr-${VDR_PLUGIN_NAME}.so.* $VDR_ROOT_DIR/plugins
cp -r $ADDON_DIR/locale/* $VDR_ROOT_DIR/locale

if [ ! -f $ADDON_HOME/.installed ] ; then
  ln -sf $ADDON_DIR/50-${VDR_PLUGIN_NAME}.conf $VDR_ROOT_DIR/args
fi

touch $ADDON_DIR/.installed $ADDON_HOME/.installed

echo "ff-vdr-plugin-${VDR_PLUGIN_NAME}/install.sh done"
