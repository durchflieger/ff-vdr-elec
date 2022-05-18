# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="ff-vdr-media-modules-aml"
PKG_VERSION="1.0.0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="local"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain media_modules-aml"
PKG_SHORTDESC="Amlogic meson linux driver."
PKG_LONGDESC="$PKG_SHORTDESC"
PKG_TOOLCHAIN="manual"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES="executable"
PKG_REV="100"

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}/overlay/lib/modules/$(get_module_dir)/media_modules-aml"
  mkdir -p ${INSTDIR}

  DRIVER_DIR=$(get_build_dir media_modules-aml)
  find $DRIVER_DIR/ -name \*.ko -not -path '*/\.*' -exec cp {} $INSTDIR \;
}
