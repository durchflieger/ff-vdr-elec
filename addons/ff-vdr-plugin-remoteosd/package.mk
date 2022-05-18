# SPDX-License-Identifier: GPL-2.0-or-later

VDR_PLUGIN_NAME="remoteosd"

PKG_NAME="ff-vdr-plugin-${VDR_PLUGIN_NAME}"
PKG_VERSION="0cf364de2e9063dab6c42e9fbc9982a51458e274"
PKG_SHA256="17c1f0651b7136ccbbea9f81afb3b7f9b06db2f37f27e6ff98557a6ed533ff1d"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-remoteosd"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-remoteosd/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-${VDR_PLUGIN_NAME}-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain ff-vdr"
PKG_NEED_UNPACK="$(get_pkg_directory ff-vdr)"
PKG_SHORTDESC="Display the menu of a remote VDR as submenu item of your local VDR menu."
PKG_LONGDESC="$PKG_SHORTDESC"
PKG_TOOLCHAIN="manual"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES="executable"
PKG_ADDON_REQUIRES="ff-vdr:0.0.0 ff-vdr-plugin-svdrpservice:0.0.0"
PKG_REV="100"

make_target() {
  VDR_DIR=$(get_build_dir ff-vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  mkdir -p ${PKG_BUILD}/locale
  make all install-i18n
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
