# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="ff-vdr"
PKG_VERSION="2.6.1"
PKG_SHA256="4717616da8e5320dceb7b44db1e4fa1b01e1d356a73717ec21225387020999c6"
PKG_LICENSE="GPL"
PKG_SITE="http://www.tvdr.de"
PKG_URL="http://git.tvdr.de/?p=vdr.git;a=snapshot;h=refs/tags/${PKG_VERSION};sf=tbz2"
PKG_SOURCE_NAME="vdr-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain bzip2 fontconfig freetype libcap libjpeg-turbo systemd"
PKG_SHORTDESC="A DVB TV server application."
PKG_LONGDESC="$PKG_SHORTDESC"
PKG_TOOLCHAIN="manual"
PKG_SECTION=""
PKG_MAINTAINER="df"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="${PKG_NAME}"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES="executable"
PKG_REV="101"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||")"
}

pre_make_target() {
  cat > Make.config <<EOF
  LIRC_DEVICE = /run/lirc/lircd
  VIDEODIR = /storage/videos
  CONFDIR = /storage/.config/vdr/config
  ARGSDIR = /storage/.config/vdr/args
  CACHEDIR = /storage/.cache/vdr
  RESDIR = /storage/.config/vdr/resources
  LIBDIR = .
  LOCDIR = ./locale
  SDNOTIFY=1
  VDR_USER=root
  REMOTE=LIRC
EOF
}

make_target() {
  make vdr vdr.pc i18n include-dir
}

addon() {
  INSTDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"
 
  mkdir -p ${INSTDIR}/{bin,locale,config}

  cp -P ${PKG_BUILD}/{diseqc.conf,keymacros.conf,scr.conf,sources.conf,svdrphosts.conf} ${INSTDIR}/config
  touch ${INSTDIR}/config/channels.conf
  echo '0.0.0.0/0' >> ${INSTDIR}/config/svdrphosts.conf

  cp -PR ${PKG_BUILD}/locale/* ${INSTDIR}/locale

  cp -P ${PKG_BUILD}/vdr ${INSTDIR}/bin/vdr
}
