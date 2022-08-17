# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ff-vdr-eventlircd"
PKG_VERSION="3b753e91ae8c28dc34dd017a354d72b3c0715309"
PKG_SHA256="4eca52d0570fa568b3296a2c9bc2af252423e25c1a67654bd79680fc5a93092a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/LibreELEC/eventlircd"
PKG_URL="https://github.com/LibreELEC/eventlircd/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain systemd lirc"
PKG_SHORTDESC="The eventlircd daemon provides four functions for LIRC devices"
PKG_LONGDESC="The eventlircd daemon provides four functions for LIRC devices and has extensions to control LGE devices"
PKG_TOOLCHAIN="autotools"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_CONFIGURE_OPTS_TARGET="--with-udev-dir=/usr/lib/udev \
                           --with-lircd-socket=/run/lirc/lircd"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES="executable"
PKG_REV="102"

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"
 
  mkdir -p ${INSTDIR}/bin

  cp -P ${PKG_INSTALL}/usr/sbin/eventlircd ${INSTDIR}/bin/ff-vdr-eventlircd
}
