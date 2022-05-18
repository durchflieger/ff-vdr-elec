#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

echo "ff-vdr/configure.sh started"

. /etc/profile
oe_setup_addon ff-vdr

VDR_ROOT_DIR=/storage/.config/vdr
VDR_CACHE_DIR=/storage/.cache/vdr
SYSD_DIR=/storage/.config/system.d

for f in vdr.service vdr-frontend.service vdr-hide-frontend.service vdr.target ; do
  systemctl disable $f
  rm -f $SYSD_DIR/$f
done

cp $ADDON_DIR/vdr.target $SYSD_DIR

if [ "$FF_VDR_FRONTEND_MODE" == "true" ] ; then
  cp $ADDON_DIR/vdr-frontend-only.service $SYSD_DIR/vdr-frontend.service
  systemctl enable vdr-frontend.service
#  srv="vdr-frontend.service"
else
  cp $ADDON_DIR/vdr.service $ADDON_DIR/vdr-frontend.service $ADDON_DIR/vdr-hide-frontend.service $SYSD_DIR
  systemctl enable vdr.service
  systemctl enable vdr-hide-frontend.service
#  srv="vdr.service"
fi

#mkdir -p $SYSD_DIR/kodi-halt.service.d $SYSD_DIR/kodi-poweroff.service.d $SYSD_DIR/kodi-reboot.service.d $SYSD_DIR/libmali.service.d
#echo -e "[Unit]\nAfter=${srv}" > $SYSD_DIR/kodi-halt.service.d/override.conf
#echo -e "[Unit]\nAfter=${srv}" > $SYSD_DIR/kodi-poweroff.service.d/override.conf
#echo -e "[Unit]\nAfter=${srv}" > $SYSD_DIR/kodi-reboot.service.d/override.conf
#echo -e "[Unit]\nBefore=${srv}" > $SYSD_DIR/libmali.service.d/override.conf

systemctl daemon-reload

if [ "$FF_VDR_BOOT_MODE" == "true" ] ; then
  grep -q -e 'systemd.unit=vdr.target' /flash/config.ini || sed -e "s/^coreelec='\(.*\)'/coreelec='\1 systemd.unit=vdr.target'/" /flash/config.ini >/tmp/config.ini && mount -o remount,rw /flash && mv /tmp/config.ini /flash/config.ini
else
  grep -q -e 'systemd.unit=vdr.target' /flash/config.ini && sed -e "s/ systemd.unit=vdr.target//" /flash/config.ini >/tmp/config.ini && mount -o remount,rw /flash && mv /tmp/config.ini /flash/config.ini
fi

echo "ff-vdr/configure.sh done"
