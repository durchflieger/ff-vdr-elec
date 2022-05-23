# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="ff-vdr-fonts-vdrsymbols"
PKG_VERSION="20100612"
PKG_SHA256="63107e25c0e4b5ae5aadef8e4323ff58a0cbd2f965827d26dba6d4f664370bf4"
PKG_LICENSE="GPL"
PKG_SITE="http://andreas.vdr-developer.org/fonts"
PKG_URL="http://andreas.vdr-developer.org/fonts/download/vdrsymbols-ttf-${PKG_VERSION}.tgz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="A truetype font based on DejaVu which also contains characters used by some plugins and patches for VDR."
PKG_LONGDESC="A truetype font based on DejaVu which also contains characters used by some plugins and patches for VDR."
PKG_TOOLCHAIN="manual"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES="executable"
PKG_REV="100"

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"
 
  mkdir -p ${INSTDIR}/fonts

  cp -P ${PKG_BUILD}/*.ttf ${INSTDIR}/fonts
}
