# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="ff-vdr-frontend"
PKG_VERSION="1.0.0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="local"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="VDR frontend control."
PKG_LONGDESC="$PKG_SHORTDESC"
PKG_TOOLCHAIN="manual"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES="executable"
PKG_ADDON_REQUIRES="ff-vdr:0.0.0 ff-vdr-plugin-softhdodroid:0.0.0"
PKG_REV="101"

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"
  mkdir -p ${INSTDIR}
}
