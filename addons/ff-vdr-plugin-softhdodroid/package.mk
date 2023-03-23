# SPDX-License-Identifier: GPL-2.0-or-later

VDR_PLUGIN_NAME="softhdodroid"

PKG_NAME="ff-vdr-plugin-${VDR_PLUGIN_NAME}"
PKG_VERSION="924c0c91e2d536d4547b61c4b298e49628eb5947"
PKG_SHA256="7dec715bd08c3e17a05c4bf98602314e4ccf6f3e3ee62bce91ff9909d031cccf"
PKG_LICENSE="GPL"
PKG_SITE="https://www.vdr-portal.de/forum/index.php?thread/134744-video-treiber-f%C3%BCr-odroid-n2-softhdodroid"
PKG_URL="https://github.com/jojo61/vdr-plugin-softhdodroid/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-${VDR_PLUGIN_NAME}-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain ff-vdr alsa freetype ffmpeg glm opengl-meson libdrm"
PKG_NEED_UNPACK="$(get_pkg_directory ff-vdr)"
PKG_SHORTDESC="A VDR video driver for Odroid hardware."
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
  make KODIBUILD=1 all install-i18n
}

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"
  mkdir -p ${INSTDIR}/locale

  #cp -PR ${PKG_BUILD}/locale/* ${INSTDIR}/locale

  VDR_DIR=$(get_build_dir ff-vdr)
  VDR_APIVERSION=$(sed -ne '/define APIVERSION/s/^.*"\(.*\)".*$/\1/p' ${VDR_DIR}/config.h)
  LIB_NAME="libvdr-${VDR_PLUGIN_NAME}.so"
  cp -P ${PKG_BUILD}/${LIB_NAME} ${INSTDIR}/${LIB_NAME}.${VDR_APIVERSION}
}

