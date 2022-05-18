#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

echo "ff-vdr/install.sh started"

. /etc/profile

oe_setup_addon ff-vdr

VDR_ROOT_DIR=/storage/.config/vdr
VDR_CACHE_DIR=/storage/.cache/vdr
SYSD_DIR=/storage/.config/system.d

chmod a+x $ADDON_DIR/bin/vdr

for d in config args plugins resources locale command-hooks recording-hooks shutdown-hooks ; do
  mkdir -p $VDR_ROOT_DIR/$d
done
mkdir -p $VDR_CACHE_DIR /storage/videos

cp -r $ADDON_DIR/locale/* $VDR_ROOT_DIR/locale

if [ ! -f $ADDON_HOME/.installed ] ; then
  cp -r $ADDON_DIR/config/* $VDR_ROOT_DIR/config

  ln -sf $ADDON_DIR/00-vdr.conf $VDR_ROOT_DIR/args
  ln -sf $ADDON_DIR/01-start-kodi.conf $VDR_ROOT_DIR/command-hooks
  ln -sf $ADDON_DIR/50-systemctl.conf $VDR_ROOT_DIR/command-hooks
  ln -sf $ADDON_DIR/S50.set-wakeup-alarm $VDR_ROOT_DIR/shutdown-hooks
  cp $ADDON_DIR/S90.custom $VDR_ROOT_DIR/shutdown-hooks
  cp $ADDON_DIR/R90.custom $VDR_ROOT_DIR/recording-hooks
  cp $ADDON_DIR/vdr-frontend-hook.sh $VDR_ROOT_DIR

  find $VDR_ROOT_DIR/command-hooks -maxdepth 1 -name '*.conf' | sort | xargs cat > $VDR_CACHE_DIR/commands.conf
  ln -sf $VDR_CACHE_DIR/commands.conf $VDR_ROOT_DIR/config

  for s in vdr.target kodi-halt.service.d kodi-poweroff.service.d kodi-reboot.service.d libmali.service.d locale.service.d remote-config.service.d smp-affinity.service.d ; do
    cp -r $ADDON_DIR/$s $SYSD_DIR
  done
  systemctl enable smp-affinity.service

  cp $ADDON_DIR/default-settings.xml $ADDON_HOME/settings.xml
fi

. $ADDON_DIR/configure.sh

touch $ADDON_DIR/.installed $ADDON_HOME/.installed

echo "ff-vdr/install.sh done"
