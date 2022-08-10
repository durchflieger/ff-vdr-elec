# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="ff-vdr-txiruinput"
PKG_VERSION="b35085817424b6ec244f7d9b0ec8c9dea37e0e48"
PKG_LICENSE="GPL"
PKG_SITE="https://media/txiruinput"
PKG_URL="git://media/txiruinput"
PKG_DEPENDS_TARGET="toolchain libusb"
PKG_SHORTDESC="txiruinput driver for usbtxir2"
PKG_LONGDESC="The txiruinput daemon handles communication to usbtxir2 device"
PKG_TOOLCHAIN="make"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES="executable"
PKG_REV="100"

GET_HANDLER_SUPPORT="git"

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"
 
  install -D -m 0755 -t ${INSTDIR}/bin ${PKG_BUILD}/txiruinput
  install -D -m 0644 -t ${INSTDIR} ${PKG_BUILD}/98-eventlircd-txiruinput.rules
}
