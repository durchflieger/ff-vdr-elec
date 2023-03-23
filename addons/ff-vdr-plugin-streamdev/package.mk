# SPDX-License-Identifier: GPL-2.0-or-later

VDR_PLUGIN_NAME="streamdev"

PKG_NAME="ff-vdr-plugin-${VDR_PLUGIN_NAME}"
PKG_VERSION="da74779591827ad7e10493b0eade65a11c525171"
PKG_SHA256="1479c64016714dfe360934359c6d22c133f30d56cd6b8792e0c861bfd5aaec23"
PKG_LICENSE="GPL"
PKG_SITE="http://projects.vdr-developer.org/projects/plg-streamdev"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-streamdev/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="vdr-plugin-${VDR_PLUGIN_NAME}-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain ff-vdr openssl"
PKG_NEED_UNPACK="$(get_pkg_directory ff-vdr)"
PKG_SHORTDESC="This PlugIn is a VDR implementation of Video Transfer and a basic HTTP Streaming Protocol."
PKG_LONGDESC="$PKG_SHORTDESC"
PKG_TOOLCHAIN="manual"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES="executable"
PKG_ADDON_REQUIRES="ff-vdr:0.0.0"
PKG_REV="102"

make_target() {
  VDR_DIR=$(get_build_dir ff-vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  mkdir -p ${PKG_BUILD}/locale
  make all
}

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"
  mkdir -p ${INSTDIR}/locale ${INSTDIR}/streamdev-server

  cp -PR ${PKG_BUILD}/locale/* ${INSTDIR}/locale
  cp -P ${PKG_BUILD}/streamdev-server/* ${INSTDIR}/streamdev-server

  VDR_DIR=$(get_build_dir ff-vdr)
  VDR_APIVERSION=$(sed -ne '/define APIVERSION/s/^.*"\(.*\)".*$/\1/p' ${VDR_DIR}/config.h)
  LIB_NAME="libvdr-${VDR_PLUGIN_NAME}"
  cp -P ${PKG_BUILD}/server/${LIB_NAME}-server.so ${INSTDIR}/${LIB_NAME}-server.so.${VDR_APIVERSION}
  cp -P ${PKG_BUILD}/client/${LIB_NAME}-client.so ${INSTDIR}/${LIB_NAME}-client.so.${VDR_APIVERSION}
}
