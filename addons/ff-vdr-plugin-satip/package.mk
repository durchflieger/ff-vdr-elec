# SPDX-License-Identifier: GPL-2.0-or-later

VDR_PLUGIN_NAME="satip"

PKG_NAME="ff-vdr-plugin-${VDR_PLUGIN_NAME}"
PKG_VERSION="0a216f1cf9d6401b1afbff420f4fa244ec15d299"
PKG_SHA256="817900c9fa5ade5c52b0391b791f801832c57bdbed5e7501d7e92b4fe29de816"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rofafor/vdr-plugin-satip"
PKG_URL="https://github.com/rofafor/vdr-plugin-satip/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="vdr-plugin-${VDR_PLUGIN_NAME}-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain ff-vdr curl tinyxml"
PKG_NEED_UNPACK="$(get_pkg_directory ff-vdr)"
PKG_SHORTDESC="This is an SAT>IP plugin for the Video Disk Recorder (VDR)."
PKG_LONGDESC="$PKG_SHORTDESC"
PKG_TOOLCHAIN="manual"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES="executable"
PKG_ADDON_REQUIRES="ff-vdr:0.0.0"
PKG_REV="100"

make_target() {
  VDR_DIR=$(get_build_dir ff-vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  mkdir -p ${PKG_BUILD}/locale
  make SATIP_USE_TINYXML=1 all install-i18n
}

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"
  mkdir -p ${INSTDIR}/locale

  cp -PR ${PKG_BUILD}/locale/* ${INSTDIR}/locale

  VDR_DIR=$(get_build_dir ff-vdr)
  VDR_APIVERSION=$(sed -ne '/define APIVERSION/s/^.*"\(.*\)".*$/\1/p' ${VDR_DIR}/config.h)
  LIB_NAME="libvdr-${VDR_PLUGIN_NAME}.so"
  cp -P ${PKG_BUILD}/${LIB_NAME} ${INSTDIR}/${LIB_NAME}.${VDR_APIVERSION}
}
