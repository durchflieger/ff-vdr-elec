# SPDX-License-Identifier: GPL-2.0-or-later

VDR_PLUGIN_NAME="dfatmo"

PKG_NAME="ff-vdr-plugin-${VDR_PLUGIN_NAME}"
PKG_VERSION="21d467e0b84f40b859447d1443363cf63afa6e9e"
PKG_SHA256="d7b9ff28b2410d0e7ba60c439f56fcb4a81aff5c8c409bf41ccf2245f256b4e1"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/durchflieger/DFAtmo"
PKG_URL="https://github.com/durchflieger/DFAtmo/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ff-vdr libusb"
PKG_NEED_UNPACK="$(get_pkg_directory ff-vdr)"
PKG_SHORTDESC="DFAtmo allows you to drive a colored back lighting for TVs similar to the Ambilight of Philips televisions."
PKG_LONGDESC="$PKG_SHORTDESC"
PKG_TOOLCHAIN="manual"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES="executable"
PKG_ADDON_REQUIRES="ff-vdr:0.0.0"
PKG_REV="101"

make_target() {
  VDR_DIR=$(get_build_dir ff-vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include
  export OUTPUTDRIVERPATH=/storage/.kodi/addons/ff-vdr-plugin-dfatmo

  #mkdir -p ${PKG_BUILD}/locale
  make -f vdr2plug.mk all install-i18n
  make outputdrivers
}

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"
  mkdir -p ${INSTDIR}
  #mkdir -p ${INSTDIR}/locale

  #cp -PR ${PKG_BUILD}/locale/* ${INSTDIR}/locale

  VDR_DIR=$(get_build_dir ff-vdr)
  VDR_APIVERSION=$(sed -ne '/define APIVERSION/s/^.*"\(.*\)".*$/\1/p' ${VDR_DIR}/config.h)
  LIB_NAME="libvdr-${VDR_PLUGIN_NAME}.so"
  cp -P ${PKG_BUILD}/${LIB_NAME} ${INSTDIR}/${LIB_NAME}.${VDR_APIVERSION}
  cp -P ${PKG_BUILD}/dfatmo-file.so ${INSTDIR}
  cp -P ${PKG_BUILD}/dfatmo-serial.so ${INSTDIR}
  cp -P ${PKG_BUILD}/dfatmo-df10ch.so ${INSTDIR}
}
