#!/bin/bash

if [ -n "$WSL_DISTRO_NAME" ] ; then
  export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib"
fi

[ -f ~/.ff-vdr-elec-options ] && source ~/.ff-vdr-elec-options

if [ -n "${FF_VDR_DISTRO_DIR}" ] ; then
	source ${FF_VDR_DISTRO_DIR}/config.sh
elif [ -f ~/ff-vdr-elec/config.sh ] ; then
	source ~/ff-vdr-elec/config.sh
else
	echo "could not find config.sh" && exit 1
fi

if [ $# -gt 0 ] ; then
  addons="$*"
  (cd $DISTRO_DIR && ADDON_OVERWRITE=yes ./scripts/create_addon $addons)
else
  addons=`sed -e 's/#.*$//' $FF_VDR_ADDON_BUILD_LIST`
  find $FF_VDR_DISTRO_DIR -name '*~' -type f -delete
  (cd $DISTRO_DIR && rm -rf target && ./scripts/create_addon $addons)
fi
